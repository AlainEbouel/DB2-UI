package model;

public class Siege {
    private int id;
    private String numero;
    private int avionId;
    private int classeId;

    public Siege(int id, String numero, int avionId, int classeId) {
        this.id = id;
        this.numero = numero;
        this.avionId = avionId;
        this.classeId = classeId;
    }

    public int getId() { return id; }
    public String getNumero() { return numero; }
    public int getAvionId() { return avionId; }
    public int getClasseId() { return classeId; }
}
