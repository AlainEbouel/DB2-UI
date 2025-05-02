package smi1002.bd2ui;

import javafx.fxml.FXML;
import javafx.scene.control.*;
import javafx.scene.layout.GridPane;
import javafx.scene.layout.StackPane;
import model.Passager;

public class MainController {

    @FXML private Button btnAjouterReservation;
    @FXML private Button btnPassagers;
    @FXML private Button btnAvions;
    @FXML private Button btnSieges;
    @FXML private Button btnVols;
    @FXML private Button btnReservations;
    @FXML private TextArea outputArea;
    @FXML private TableColumn<Passager, Integer> colId;
    @FXML private TableColumn<model.Passager, String> colPrenom;
    @FXML private TableColumn<model.Passager, String> colNom;
    @FXML private StackPane tableContainer;

    private TableView<model.Passager> passagerTable = new TableView<>();
    private TableView<model.Avion> avionTable = new TableView<>();
    private TableView<model.Siege> siegeTable = new TableView<>();
    private TableView<model.Vol> volTable = new TableView<>();
    private TableView<model.Reservation> reservationTable = new TableView<>();

    @FXML
    public void initialize() {

        TableColumn<model.Passager, Integer> colIdP = new TableColumn<>("ID");
        TableColumn<model.Passager, String> colPrenom = new TableColumn<>("Prénom");
        TableColumn<model.Passager, String> colNom = new TableColumn<>("Nom");

        colIdP.setCellValueFactory(data -> new javafx.beans.property.SimpleIntegerProperty(data.getValue().getId()).asObject());
        colPrenom.setCellValueFactory(data -> new javafx.beans.property.SimpleStringProperty(data.getValue().getPrenom()));
        colNom.setCellValueFactory(data -> new javafx.beans.property.SimpleStringProperty(data.getValue().getNom()));
        passagerTable.getColumns().addAll(colIdP, colPrenom, colNom);

        // Colonnes Avion
        TableColumn<model.Avion, Integer> colIdA = new TableColumn<>("ID");
        TableColumn<model.Avion, String> colModele = new TableColumn<>("Modèle");
        TableColumn<model.Avion, Integer> colCapacite = new TableColumn<>("Capacité");

        colIdA.setCellValueFactory(data -> new javafx.beans.property.SimpleIntegerProperty(data.getValue().getId()).asObject());
        colModele.setCellValueFactory(data -> new javafx.beans.property.SimpleStringProperty(data.getValue().getModele()));
        colCapacite.setCellValueFactory(data -> new javafx.beans.property.SimpleIntegerProperty(data.getValue().getCapacite()).asObject());
        avionTable.getColumns().addAll(colIdA, colModele, colCapacite);

        TableColumn<model.Siege, Integer> colSiegeId = new TableColumn<>("ID");
        TableColumn<model.Siege, String> colNumero = new TableColumn<>("Numéro");
        TableColumn<model.Siege, Integer> colAvionId = new TableColumn<>("Avion ID");
        TableColumn<model.Siege, Integer> colClasseId = new TableColumn<>("Classe ID");

        colSiegeId.setCellValueFactory(d -> new javafx.beans.property.SimpleIntegerProperty(d.getValue().getId()).asObject());
        colNumero.setCellValueFactory(d -> new javafx.beans.property.SimpleStringProperty(d.getValue().getNumero()));
        colAvionId.setCellValueFactory(d -> new javafx.beans.property.SimpleIntegerProperty(d.getValue().getAvionId()).asObject());
        colClasseId.setCellValueFactory(d -> new javafx.beans.property.SimpleIntegerProperty(d.getValue().getClasseId()).asObject());
        siegeTable.getColumns().addAll(colSiegeId, colNumero, colAvionId, colClasseId);

        TableColumn<model.Vol, Integer> colVolId = new TableColumn<>("ID");
        TableColumn<model.Vol, String> colVolNumero = new TableColumn<>("Numéro");
        TableColumn<model.Vol, String> colVolDate = new TableColumn<>("Départ");

        colVolId.setCellValueFactory(d -> new javafx.beans.property.SimpleIntegerProperty(d.getValue().getId()).asObject());
        colVolNumero.setCellValueFactory(d -> new javafx.beans.property.SimpleStringProperty(d.getValue().getNumero()));
        colVolDate.setCellValueFactory(d -> new javafx.beans.property.SimpleStringProperty(d.getValue().getDateDepart()));
        volTable.getColumns().addAll(colVolId, colVolNumero, colVolDate);

        TableColumn<model.Reservation, Integer> colResId = new TableColumn<>("ID");
        TableColumn<model.Reservation, String> colResVol = new TableColumn<>("Vol");
        TableColumn<model.Reservation, String> colResDate = new TableColumn<>("Date");
        TableColumn<model.Reservation, String> colResSiege = new TableColumn<>("Siège");
        TableColumn<model.Reservation, String> colResClasse = new TableColumn<>("Classe");

        colResId.setCellValueFactory(d -> new javafx.beans.property.SimpleIntegerProperty(d.getValue().getId()).asObject());
        colResVol.setCellValueFactory(d -> new javafx.beans.property.SimpleStringProperty(d.getValue().getVol()));
        colResDate.setCellValueFactory(d -> new javafx.beans.property.SimpleStringProperty(d.getValue().getDate()));
        colResSiege.setCellValueFactory(d -> new javafx.beans.property.SimpleStringProperty(d.getValue().getSiege()));
        colResClasse.setCellValueFactory(d -> new javafx.beans.property.SimpleStringProperty(d.getValue().getClasse()));
        reservationTable.getColumns().addAll(colResId, colResVol, colResDate, colResSiege, colResClasse);

        btnPassagers.setOnAction(e -> {
            tableContainer.getChildren().setAll(passagerTable);
            loadPassagers();
        });

        btnAvions.setOnAction(e -> {
            tableContainer.getChildren().setAll(avionTable);
            loadAvions();
        });
        btnSieges.setOnAction(e -> {
            tableContainer.getChildren().setAll(siegeTable);
            loadSieges();
        });
        btnVols.setOnAction(e -> {
            tableContainer.getChildren().setAll(volTable);
            loadVols();
        });
        btnReservations.setOnAction(e -> {
            TextInputDialog dialog = new TextInputDialog();
            dialog.setTitle("Réservations");
            dialog.setHeaderText("Entrer l'ID du passager");
            dialog.setContentText("ID :");

            dialog.showAndWait().ifPresent(input -> {
                try {
                    int id = Integer.parseInt(input);
                    tableContainer.getChildren().setAll(reservationTable);
                    loadReservations(id);
                } catch (NumberFormatException ex) {
                    System.out.println("ID invalide.");
                }
            });
        });
//        btnAjouterReservation.setOnAction(e -> {
//            Dialog<ButtonType> dialog = new Dialog<>();
//            dialog.setTitle("Nouvelle réservation");
//
//            GridPane grid = new GridPane();
//            grid.setVgap(10);
//            grid.setHgap(10);
//
//            ComboBox<Integer> cbPassager = new ComboBox<>();
//            ComboBox<Integer> cbVol = new ComboBox<>();
//            ComboBox<Integer> cbSiege = new ComboBox<>();
//            ComboBox<Integer> cbClasse = new ComboBox<>();
//
//            grid.add(new Label("ID Passager :"), 0, 0);
//            grid.add(cbPassager, 1, 0);
//            grid.add(new Label("ID Vol :"), 0, 1);
//            grid.add(cbVol, 1, 1);
//            grid.add(new Label("ID Siège :"), 0, 2);
//            grid.add(cbSiege, 1, 2);
//            grid.add(new Label("ID Classe :"), 0, 3);
//            grid.add(cbClasse, 1, 3);
//
//
//            dialog.getDialogPane().setContent(grid);
//            dialog.getDialogPane().getButtonTypes().addAll(ButtonType.OK, ButtonType.CANCEL);
//
//            try (var conn = util.ConnexionOracle.getConnection()) {
//                var rs1 = conn.createStatement().executeQuery("SELECT passager_id FROM Passager");
//                while (rs1.next()) cbPassager.getItems().add(rs1.getInt(1));
//
//                var rs2 = conn.createStatement().executeQuery("SELECT vol_id FROM Vol");
//                while (rs2.next()) cbVol.getItems().add(rs2.getInt(1));
//
//                var rs3 = conn.createStatement().executeQuery(
//                        "SELECT siege_id FROM Siege WHERE siege_id NOT IN (SELECT siege_id FROM Reservation)");
//                while (rs3.next()) cbSiege.getItems().add(rs3.getInt(1));
//
//                var rs4 = conn.createStatement().executeQuery("SELECT classe_id FROM Classe");
//                while (rs4.next()) cbClasse.getItems().add(rs4.getInt(1));
//            } catch (Exception ex) {
//                ex.printStackTrace();
//                showAlert("Erreur", "Impossible de charger les options.");
//            }
//
//            dialog.showAndWait().ifPresent(response -> {
//                if (response == ButtonType.OK) {
//                    try {
//                        Integer passagerId = cbPassager.getValue();
//                        Integer volId = cbVol.getValue();
//                        Integer siegeId = cbSiege.getValue();
//                        Integer classeId = cbClasse.getValue();
//
//                        if (passagerId != null && volId != null && siegeId != null && classeId != null) {
//                            ajouterReservation(passagerId, volId, siegeId, classeId);
//                        } else {
//                            showAlert("Erreur", "Veuillez sélectionner toutes les options.");
//                        }
//
////                        int volId = Integer.parseInt(tfVol.getText());
////                        int siegeId = Integer.parseInt(tfSiege.getText());
////                        int classeId = Integer.parseInt(tfClasse.getText());
//
//                        ajouterReservation(passagerId, volId, siegeId, classeId);
//                    } catch (Exception ex) {
//                        showAlert("Erreur", "Entrées invalides.");
//                    }
//                }
//            });
//        });



    }
    private void loadPassagers() {
        passagerTable.getItems().clear();
        try (var conn = util.ConnexionOracle.getConnection();
             var stmt = conn.createStatement();
             var rs = stmt.executeQuery("SELECT passager_id, nom, prenom FROM Passager")) {
            while (rs.next()) {
                passagerTable.getItems().add(new model.Passager(rs.getInt(1), rs.getString(3), rs.getString(2)));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    private void loadAvions() {
        avionTable.getItems().clear();
        try (var conn = util.ConnexionOracle.getConnection();
             var stmt = conn.createStatement();
             var rs = stmt.executeQuery("SELECT avion_id, modele, capacite FROM Avion")) {
            while (rs.next()) {
                avionTable.getItems().add(new model.Avion(rs.getInt(1), rs.getString(2), rs.getInt(3)));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    private void loadSieges() {
        siegeTable.getItems().clear();
        try (var conn = util.ConnexionOracle.getConnection();
             var stmt = conn.createStatement();
             var rs = stmt.executeQuery("SELECT siege_id, numero_siege, avion_id, classe_id FROM Siege WHERE siege_id NOT IN (SELECT siege_id FROM Reservation)")) {
            while (rs.next()) {
                siegeTable.getItems().add(new model.Siege(rs.getInt(1), rs.getString(2), rs.getInt(3), rs.getInt(4)));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    private void loadVols() {
        volTable.getItems().clear();
        try (var conn = util.ConnexionOracle.getConnection();
             var stmt = conn.createStatement();
             var rs = stmt.executeQuery("SELECT vol_id, numero_vol, TO_CHAR(date_depart, 'YYYY-MM-DD HH24:MI') FROM Vol")) {
            while (rs.next()) {
                volTable.getItems().add(new model.Vol(rs.getInt(1), rs.getString(2), rs.getString(3)));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    private void loadReservations(int passagerId) {
        reservationTable.getItems().clear();
        try (var conn = util.ConnexionOracle.getConnection();
             var stmt = conn.prepareStatement("""                             
                     SELECT r.reservation_id, v.numero_vol, TO_CHAR(v.date_depart, 'YYYY-MM-DD HH24:MI'),
                     s.numero_siege, c.nom
                     FROM Reservation r
                     JOIN Vol v ON r.vol_id = v.vol_id
                     JOIN Siege s ON r.siege_id = s.siege_id
                     JOIN Classe c ON r.classe_id = c.classe_id
                     WHERE r.passager_id = ?
         """)) {
            stmt.setInt(1, passagerId);
            var rs = stmt.executeQuery();
            while (rs.next()) {
                reservationTable.getItems().add(
                        new model.Reservation(rs.getInt(1), rs.getString(2), rs.getString(3),
                                rs.getString(4), rs.getString(5)));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    private void ajouterReservation(int passagerId, int volId, int siegeId, int classeId) {
        try (var conn = util.ConnexionOracle.getConnection();
             var stmt = conn.prepareStatement("""
                     INSERT INTO Reservation (reservation_id, passager_id, vol_id, date_reservation, siege_id, classe_id)
                     VALUES (seq_reservation_id.NEXTVAL, ?, ?, SYSDATE, ?, ?)
         """)) {
            stmt.setInt(1, passagerId);
            stmt.setInt(2, volId);
            stmt.setInt(3, siegeId);
            stmt.setInt(4, classeId);

            int lignes = stmt.executeUpdate();
            if (lignes > 0) showAlert("Succès", "Réservation ajoutée avec succès.");
            else showAlert("Erreur", "Aucune réservation enregistrée.");
        } catch (Exception e) {
            e.printStackTrace();
            showAlert("Erreur", "Échec lors de l’ajout.");
        }
    }

    private void showAlert(String titre, String contenu) {
        Alert alert = new Alert(Alert.AlertType.INFORMATION);
        alert.setTitle(titre);
        alert.setContentText(contenu);
        alert.showAndWait();
    }



}