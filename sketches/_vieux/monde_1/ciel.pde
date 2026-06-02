/**
* Le ciel 
* 2026-2026 v 0.0.1
*
*/


int ciel () {
    int hue = 210; // bleu
    int start_value = 50;
    int var_sat = start_value + int(sin(millis() * 0.0001)*50);
    int var_bri = start_value + int(cos(millis() * 0.000035)*50);
    int c = color(hue, var_sat, var_bri);
    return c;
}