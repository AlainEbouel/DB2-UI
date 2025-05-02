package model;

public class Reservation {
    private int id;
    private String vol;
    private String date;
    private String siege;
    private String classe;

    public Reservation(int id, String vol, String date, String siege, String classe) {
        this.id = id;
        this.vol = vol;
        this.date = date;
        this.siege = siege;
        this.classe = classe;
    }

    public int getId() { return id; }
    public String getVol() { return vol; }
    public String getDate() { return date; }
    public String getSiege() { return siege; }
    public String getClasse() { return classe; }
}
