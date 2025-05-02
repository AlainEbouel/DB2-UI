package model;

public class Avion {
    private int id;
    private String modele;
    private int capacite;

    public Avion(int id, String modele, int capacite) {
        this.id = id;
        this.modele = modele;
        this.capacite = capacite;
    }

    public int getId() { return id; }
    public String getModele() { return modele; }
    public int getCapacite() { return capacite; }
}
