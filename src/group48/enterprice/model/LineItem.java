package group48.enterprice.model;

public class LineItem {
    private Provision provision;
    private int quantity;

    public LineItem(Provision provision, int quantity) {
        super();
        this.provision = provision;
        this.quantity = quantity;
    }
    public Provision getProvision() {
        return provision;
    }
    public void setProvision(Provision provision) {
        this.provision = provision;
    }
    public int getQuantity() {
        return quantity;
    }
    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }

}
