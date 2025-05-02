module smi1002.bd2ui {
    requires javafx.controls;
    requires javafx.fxml;
    requires java.sql;


    opens smi1002.bd2ui to javafx.fxml;
    exports smi1002.bd2ui;
}