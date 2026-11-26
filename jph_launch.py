#!/usr/bin/env python3
"""Start the Minecraft 26.3 already installed on this Mac."""

import json
import subprocess
import sys
import time
from pathlib import Path

import requests
import minecraft_launcher_lib.command as command
import minecraft_launcher_lib.microsoft_account as microsoft

ROOT = Path(__file__).resolve().parent
GAME = ROOT / "game"
MINECRAFT = Path.home() / "Library/Application Support/minecraft"
VERSION = "26.3"
ACCOUNT = ROOT / "account.json"
CLIENT = ROOT / "client_id"
NOTICE = ROOT / "session.txt"
# shortcut: token 0 is a local session, online servers reject it until a real Microsoft login exists


def dashed(uuid: str) -> str:
    raw = uuid.replace("-", "")
    if len(raw) != 32:
        return uuid
    return f"{raw[:8]}-{raw[8:12]}-{raw[12:16]}-{raw[16:20]}-{raw[20:]}"


def local_profile() -> dict:
    name, uuid = "ReplayClips", "f53510efb5bf40c092071ef95bc13329"
    path = MINECRAFT / "launcher_accounts.json"
    if path.is_file():
        for account in json.loads(path.read_text()).get("accounts", {}).values():
            profile = account.get("minecraftProfile") or {}
            if profile.get("name") and profile.get("id"):
                name, uuid = profile["name"], profile["id"]
                break
    return {"name": name, "id": uuid, "access_token": "0"}


def minecraft_command(profile: dict, version: str = VERSION, ram: str = "2G", game: Path | None = None) -> list[str]:
    folder = game or GAME
    argv = command.get_minecraft_command(version, MINECRAFT, {
        "username": profile["name"],
        "uuid": dashed(profile["id"]),
        "token": profile["access_token"],
        "gameDirectory": str(folder),
        "jvmArguments": [f"-Xmx{ram if ram.endswith('G') and ram[:-1].isdigit() else '2G'}"],
        "launcherName": "JPH Launcher",
        "launcherVersion": "0.1",
    })
    xuid = str(profile.get("xuid") or "0")
    return [part.replace("${clientid}", "").replace("${auth_xuid}", xuid) for part in argv]


def check() -> None:
    argv = minecraft_command({"name": "ReplayClips", "id": "a" * 32, "access_token": "check-token"})
    assert argv[0].endswith("/java") and "java-runtime-epsilon" in argv[0], argv[0]
    assert "--demo" not in argv
    assert "ReplayClips" in argv and "check-token" in argv
    assert str(GAME) in argv and "net.minecraft.client.main.Main" in argv
    assert "${clientid}" not in argv and "${auth_xuid}" not in argv
    marked = minecraft_command({"name": "ReplayClips", "id": "a" * 32, "access_token": "check-token", "xuid": "12345"})
    assert marked[marked.index("--xuid") + 1] == "12345"
    print("check ok")


def use_fullscreen(enabled: bool = True, game: Path | None = None) -> None:
    folder = game or GAME
    path = folder / "options.txt"
    line = "fullscreen:true" if enabled else "fullscreen:false"
    folder.mkdir(parents=True, exist_ok=True)
    if not path.exists():
        path.write_text(line + "\n")
        return
    rows = path.read_text().splitlines()
    for index, row in enumerate(rows):
        if row.startswith("fullscreen:"):
            rows[index] = line
            break
    else:
        rows.append(line)
    path.write_text("\n".join(rows) + "\n")


def launch_options() -> tuple[str, str, bool, Path]:
    version, ram, fullscreen, game = VERSION, "2G", True, GAME
    args = sys.argv[1:]
    index = 0
    while index < len(args):
        arg = args[index]
        if arg == "--ram" and index + 1 < len(args):
            ram = args[index + 1]
            index += 2
        elif arg == "--window":
            fullscreen = False
            index += 1
        elif arg == "--fullscreen":
            fullscreen = True
            index += 1
        elif arg == "--game" and index + 1 < len(args):
            game = Path(args[index + 1])
            index += 2
        elif not arg.startswith("-"):
            version = arg
            index += 1
        else:
            index += 1
    return version, ram, fullscreen, game


class LoginError(Exception):
    pass


def client_id() -> str | None:
    if not CLIENT.is_file():
        return None
    value = CLIENT.read_text().strip()
    return value or None


def load_account() -> dict | None:
    if not ACCOUNT.is_file():
        return None
    try:
        data = json.loads(ACCOUNT.read_text())
    except json.JSONDecodeError:
        return None
    if not data.get("refresh_token") or not data.get("name") or not data.get("id"):
        return None
    return data


def save_account(data: dict) -> None:
    ACCOUNT.write_text(json.dumps({
        "name": data["name"],
        "id": data["id"],
        "refresh_token": data["refresh_token"],
        "xuid": data.get("xuid") or "0",
    }))
    ACCOUNT.chmod(0o600)


def note(line: str) -> None:
    NOTICE.write_text(line + "\n")


def claim_xuid(payload: dict) -> str:
    try:
        claim = payload["DisplayClaims"]["xui"][0]
    except (KeyError, IndexError, TypeError):
        return "0"
    return str(claim.get("xid") or "0")


def minecraft_from_microsoft(access_token: str, refresh_token: str, xuid: str = "0") -> dict:
    xbl = microsoft.authenticate_with_xbl(access_token)
    if "Token" not in xbl:
        raise LoginError("Microsoft did not allow this account.")
    xsts = microsoft.authenticate_with_xsts(xbl["Token"])
    if "Token" not in xsts:
        code = xsts.get("XErr")
        if code == 2148916233:
            raise LoginError("This Microsoft account has no Xbox profile.")
        if code == 2148916238:
            raise LoginError("This account needs an adult to sign in.")
        raise LoginError("Microsoft did not allow this account.")
    userhash = xsts["DisplayClaims"]["xui"][0]["uhs"]
    found = claim_xuid(xsts)
    if found == "0":
        found = claim_xuid(xbl) if xuid == "0" else xuid
    account = microsoft.authenticate_with_minecraft(userhash, xsts["Token"])
    if "access_token" not in account:
        raise LoginError("This app id is not approved yet.")
    profile = microsoft.get_profile(account["access_token"])
    if profile.get("error") == "NOT_FOUND" or "id" not in profile:
        raise LoginError("This Microsoft account does not own Minecraft.")
    return {
        "name": profile["name"],
        "id": profile["id"],
        "access_token": account["access_token"],
        "refresh_token": refresh_token,
        "xuid": found if found != "0" else xuid,
    }


def refresh_saved() -> tuple[dict | None, str]:
    saved = load_account()
    cid = client_id()
    if not cid or not saved:
        return None, "Sign in to play online."
    try:
        token = requests.post(
            "https://login.microsoftonline.com/consumers/oauth2/v2.0/token",
            data={
                "client_id": cid,
                "grant_type": "refresh_token",
                "refresh_token": saved["refresh_token"],
                "scope": "XboxLive.signin offline_access",
            },
            timeout=30,
        ).json()
    except requests.RequestException:
        return None, "Sign in to play online."
    if "access_token" not in token or "refresh_token" not in token:
        return None, "Sign in again to play online."
    try:
        fresh = minecraft_from_microsoft(token["access_token"], token["refresh_token"], str(saved.get("xuid") or "0"))
    except LoginError as error:
        return None, str(error)
    except (KeyError, TypeError, requests.RequestException):
        return None, "Sign in again to play online."
    save_account(fresh)
    return fresh, "online"


def device_login() -> None:
    cid = client_id()
    if not cid:
        print("error Add your app id to client_id. Use a personal Microsoft account and a public client, then submit the AppID review.", flush=True)
        return
    try:
        started = requests.post(
            "https://login.microsoftonline.com/consumers/oauth2/v2.0/devicecode",
            data={"client_id": cid, "scope": "XboxLive.signin offline_access"},
            timeout=30,
        ).json()
    except requests.RequestException:
        print("error Microsoft did not start sign-in.", flush=True)
        return
    if "user_code" not in started or "device_code" not in started:
        print("error Microsoft did not start sign-in.", flush=True)
        return
    print(f"code {started['user_code']}", flush=True)
    print(f"url {started.get('verification_uri') or 'https://www.microsoft.com/link'}", flush=True)
    interval = int(started.get("interval") or 5)
    deadline = time.time() + int(started.get("expires_in") or 900)
    while time.time() < deadline:
        time.sleep(interval)
        try:
            token = requests.post(
                "https://login.microsoftonline.com/consumers/oauth2/v2.0/token",
                data={
                    "grant_type": "urn:ietf:params:oauth:grant-type:device_code",
                    "client_id": cid,
                    "device_code": started["device_code"],
                },
                timeout=30,
            ).json()
        except requests.RequestException:
            continue
        if "access_token" in token and "refresh_token" in token:
            try:
                fresh = minecraft_from_microsoft(token["access_token"], token["refresh_token"])
            except LoginError as error:
                print(f"error {error}", flush=True)
                return
            except (KeyError, TypeError, requests.RequestException):
                print("error Microsoft did not finish sign-in.", flush=True)
                return
            save_account(fresh)
            print(f"ok {fresh['name']}", flush=True)
            return
        error = token.get("error")
        if error == "authorization_pending":
            continue
        if error == "slow_down":
            interval += 5
            continue
        if error == "expired_token":
            print("error That code expired. Sign in again.", flush=True)
            return
        if error == "access_denied":
            print("error Sign-in was declined.", flush=True)
            return
        print("error Microsoft did not finish sign-in.", flush=True)
        return
    print("error That code expired. Sign in again.", flush=True)


def sign_out() -> None:
    if ACCOUNT.exists():
        ACCOUNT.unlink()
    print("ok", flush=True)


def who() -> None:
    saved = load_account()
    print(saved["name"] if saved else "signed-out", flush=True)


def fabric_profile(version: str) -> str | None:
    note = ROOT / "fabric" / f"{version}.id"
    if not note.is_file():
        return None
    chosen = note.read_text().strip()
    meta = MINECRAFT / "versions" / chosen / f"{chosen}.json"
    return chosen if meta.is_file() else None


def start(version: str | None = None) -> subprocess.Popen:
    chosen, ram, fullscreen, game = launch_options()
    if version:
        chosen = version
    if profile := fabric_profile(chosen):
        chosen = profile
    game.mkdir(parents=True, exist_ok=True)
    use_fullscreen(fullscreen, game)
    profile, message = refresh_saved()
    if profile is None:
        profile = local_profile()
    note(message)
    argv = minecraft_command(profile, chosen, ram, game)
    return subprocess.Popen(argv, cwd=game, start_new_session=True)


def launch() -> None:
    start()


if __name__ == "__main__":
    if "--check" in sys.argv:
        check()
    elif "--login" in sys.argv:
        device_login()
    elif "--name" in sys.argv:
        who()
    elif "--sign-out" in sys.argv:
        sign_out()
    else:
        launch()
