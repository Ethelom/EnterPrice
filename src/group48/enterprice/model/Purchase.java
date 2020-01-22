package group48.enterprice.model;

import java.sql.Date;
import java.util.ArrayList;
import java.util.List;


public class Purchase {
    private int purchaseID;
    private double totalCost;
    private Date date;
    private List<LineItem> products = new ArrayList<LineItem>();

    public Purchase(int purchaseID, Date date, double totalCost) {
        super();
        this.purchaseID = purchaseID;
        this.date = date;
        this.totalCost = totalCost;
    }

    public List<Purchase> divideIntoSubpurchases() {
        //iterate through products to create a unique purchase for each unique store
        List<Purchase> subpurchases = new ArrayList<Purchase>();
        for(LineItem item : products) {
            Store store = item.getProvision().getStore();
            int index = storeIsUniqueSoFar(subpurchases, store);
            if(index == -1) {
                //create new subpurchase
                Purchase purchase = new Purchase(0, null, 0);
                purchase.addLineItemToProducts(item);
                subpurchases.add(purchase);
            } else {
                //add to existent subpurchase
                subpurchases.get(index).addLineItemToProducts(item);
            }
        }
        for(Purchase subpurchase : subpurchases) {
            subpurchase.setTotalCost(calculateTotalCostOfPurchase(subpurchase.getProducts()));
        }
        return subpurchases;
    }

    public double calculateTotalCostOfPurchase(List<LineItem> products) {
        double cost = 0;
        for(LineItem item : products) {
            cost += item.getQuantity() * item.getProvision().getPrice();
        }
        return cost;
    }

    private int storeIsUniqueSoFar(List<Purchase> subpurchases, Store store) {
        int index = -1;
        int i = 0;
        for(Purchase subpurchase : subpurchases) {
            LineItem item = subpurchase.getProducts().get(0);
            if(item.getProvision().getStore().equals(store)) {
                index = i;
                break;
            }
            i++;
        }
        return index;
    }

    public void addLineItemToProducts(LineItem item) {
        products.add(item);
    }

    public void setProducts(List<LineItem> products) {
        this.products = products;
    }

    public List<LineItem> getProducts() {
        return products;
    }

    public int getPurchaseID() {
        return purchaseID;
    }

    public void setPurchaseID(int purchaseID) {
        this.purchaseID = purchaseID;
    }

    public double getTotalCost() {
        return totalCost;
    }

    public void setTotalCost(double totalCost) {
        this.totalCost = totalCost;
    }

    public Date getDate() {
        return date;
    }

    public void setDate(Date date) {
        this.date = date;
    }

}
