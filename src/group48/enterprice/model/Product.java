package group48.enterprice.model;

import java.io.Serializable;
import java.util.HashMap;
import java.util.LinkedHashMap;

@SuppressWarnings("serial")
public class Product implements Comparable<Product>, Serializable{

    public enum Category {
        TECHNOLOGY,
        FASHION,
        HOME,
        SPORTS,
        STATIONERY;

        @Override
        public String toString() {
            return name().substring(0,1).toUpperCase() + name().substring(1).toLowerCase();
        }
    }

    Category category;
    String productName, productImage, subCategory, brand, color;
    LinkedHashMap<String, String> specs;

    public Product(String productName, String productImage, Category category, String subCategory, String brand, String color) {
        this.productName = productName;
        this.productImage = productImage;
        this.category = category;
        this.subCategory = subCategory;
        this.brand = brand;
        this.color = color;
        specs = new LinkedHashMap<String, String>();
        initialiseSpecsWithBrandAndColor();

    }

    public boolean equals(Product otherProduct) {
        return (this.productName.equals(otherProduct.getProductName()));
    }

    private void initialiseSpecsWithBrandAndColor() {
        specs.put("Brand", getBrand());
        specs.put("Color", getColor());
    }

    public void addToSpecs(String key, String value) {
        specs.put(key, value);
    }

    @Override
    public int compareTo(Product otherProduct) {
        return this.getProductName().compareTo(otherProduct.getProductName());
    }

    public static boolean subcategoryIsValid(String subcategory) {
        switch(subcategory) {
        case "Smartphone":
        case "Laptop":
        case "Camera":
        case "TV":
        case "Suit":
        case "Shirt":
        case "Dress":
        case "Shoes":
        case "Fridge":
        case "Couch":
        case "Bed":
        case "Table":
        case "Basketball":
        case "Soccer":
        case "Tennis":
        case "Snowboard":
        case "Book":
        case "Pen":
        case "Notebook":
        case "Bookmark":
            return true;
        default:
            return false;

        }
    }

    public HashMap<String, String> getSpecs() {
        return specs;
    }

    public String getProductName() {
        return productName;
    }

    public void setProductName(String productName) {
        this.productName = productName;
    }

    public String getProductImage() {
        return productImage;
    }

    public void setProductImage(String productImage) {
        this.productImage = productImage;
    }

    public Category getCategory() {
        return category;
    }

    public void setCategory(Category category) {
        this.category = category;
    }

    public String getSubCategory() {
        return subCategory;
    }

    public void setSubCategory(String subCategory) {
        this.subCategory = subCategory;
    }

    public String getBrand() {
        return brand;
    }

    public void setBrand(String brand) {
        this.brand = brand;
    }

    public String getColor() {
        return color;
    }

    public void setColor(String color) {
        this.color = color;
    }
}
