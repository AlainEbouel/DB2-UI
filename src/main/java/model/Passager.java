package model;

public class Passager {
    private int id;
    private String prenom;
    private String nom;

    public Passager(int id, String prenom, String nom) {
        this.id = id;
        this.prenom = prenom;
        this.nom = nom;
    }

    public int getId() { return id; }
    public String getPrenom() { return prenom; }
    public String getNom() { return nom; }
}
