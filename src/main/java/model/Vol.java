package model;

public class Vol {
    private int id;
    private String numero;
    private String dateDepart;

    public Vol(int id, String numero, String dateDepart) {
        this.id = id;
        this.numero = numero;
        this.dateDepart = dateDepart;
    }

    public int getId() { return id; }
    public String getNumero() { return numero; }
    public String getDateDepart() { return dateDepart; }
}
