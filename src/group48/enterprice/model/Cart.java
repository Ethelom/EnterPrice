package group48.enterprice.model;

import java.util.ArrayList;
import java.util.List;

public class Cart {
    private List<LineItem> products;

    public Cart() {
        products = new ArrayList<LineItem>();
    }

    public boolean contains(LineItem otherLineItem) {
        for(LineItem item : products) {
            if(item.equals(otherLineItem)) {
                return true;
            }
        }
        return false;
    }

    public boolean containsItem(Provision provision) {
        boolean found = false;
        for(LineItem item : products) {
            if(item.getProvision().equals(provision)) {
                found = true;
                break;
            }
        }
        return found;
    }

    public void addToCart(LineItem item) {
        this.products.add(item);
    }

    public List<LineItem> getProducts() {
        return this.products;
    }
}
