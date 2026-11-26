package jph;

/** One toggle. A slider is optional and only moves while the hack is on. */
public final class Hack {
    public final String name;
    public final double min;
    public final double max;
    public final String suffix;
    public boolean on;
    public double value;

    public Hack(String name) {
        this(name, 0, 0, 0, "");
    }

    public Hack(String name, double min, double max, double value, String suffix) {
        this.name = name;
        this.min = min;
        this.max = max;
        this.suffix = suffix;
        this.value = value;
    }

    public boolean slider() {
        return max > min;
    }

    public void setFrom(double fraction) {
        double next = min + (max - min) * Math.min(1, Math.max(0, fraction));
        value = Math.round(next * 10.0) / 10.0;
    }

    public String label() {
        if (!slider()) {
            return on ? "On" : "Off";
        }
        String text = value == Math.rint(value) ? Integer.toString((int) value) : String.format(java.util.Locale.US, "%.1f", value);
        return text + suffix;
    }
}
