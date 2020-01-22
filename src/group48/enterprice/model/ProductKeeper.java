package group48.enterprice.model;

import java.util.ArrayList;
import java.util.List;

public class ProductKeeper {
    private List<Product> savedProducts;

    public ProductKeeper(List<Product> savedProducts) {
        this.savedProducts = savedProducts;
    }

    public List<Product> getRequestedSubcategoryProducts(String subcategory) {
        List<Product> returnedProducts = new ArrayList<Product>();
        for(Product product : savedProducts) {
            if(product.getSubCategory().equals(subcategory)) {
                returnedProducts.add(product);
            }
        }
        return returnedProducts;
    }

    public List<Product> getSavedProducts() {
        return savedProducts;
    }

    public void setSavedProducts(List<Product> savedProducts) {
        this.savedProducts = savedProducts;
    }


}
