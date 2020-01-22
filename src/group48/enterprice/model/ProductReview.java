package group48.enterprice.model;

public class ProductReview {
    private Customer customer;
    private Product product;
    private int rating;
    private String reviewBody;
    private String username;
    private String timestamp;

    public ProductReview(Customer customer, Product product, int rating, String reviewBody) {
        this.customer = customer;
        this.product = product;
        this.rating = rating;
        this.reviewBody = reviewBody;
    }

    public ProductReview(String username, Product product, int rating, String reviewBody, String timestamp) {
        this.username = username;
        this.product = product;
        this.rating = rating;
        this.reviewBody = reviewBody;
        this.timestamp = timestamp;
    }

    public String getUsername() {
        if(this.customer != null) {
            return customer.getUsername();
        } else {
            return this.username;
        }
    }

    public String getTimestamp() {
        return timestamp;
    }

    public void setTimestamp(String timestamp) {
        this.timestamp = timestamp;
    }

    public Customer getCustomer() {
        return customer;
    }

    public void setCustomer(Customer customer) {
        this.customer = customer;
    }

    public Product getProduct() {
        return product;
    }

    public void setProduct(Product product) {
        this.product = product;
    }

    public int getRating() {
        return rating;
    }

    public void setRating(int rating) {
        this.rating = rating;
    }

    public String getReviewBody() {
        return reviewBody;
    }

    public void setReviewBody(String reviewBody) {
        this.reviewBody = reviewBody;
    }


    @Override
    public String toString() {
        return "ProductReview [customer=" + customer + ", product=" + product
            + ", rating=" + rating + ", reviewBody=" + reviewBody + "]";
    }
}
