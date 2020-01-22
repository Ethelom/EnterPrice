package group48.enterprice.database;

public class Query {

    protected final String UPDATE_STORE_QUERY = "UPDATE business_account SET website = ?, store_name = ?, bank_number = ? WHERE b_username = ?;";

    protected static final String FIND_PRODUCT = "SELECT * FROM product WHERE product_name=?";

    protected static final String FIND_ALL_BOUGHT_PRODUCTS_CUSTOMER = "SELECT product_purchase.* , purchase.purchase_date, purchase.total_cost, business_account.b_username \r\n" +
        "FROM product_purchase\r\n" +
        "INNER JOIN purchase ON purchase.purchase_id = product_purchase.purchase_id\r\n" +
        "INNER JOIN business_account ON business_account.b_username = purchase.b_username\r\n" +
        "INNER JOIN product ON product_purchase.product_name = product.product_name\r\n" +
        "WHERE purchase.cust_username = ? \r\n" +
        "ORDER BY purchase_id DESC;";

    protected static final String FIND_ALL_BOUGHT_PRODUCTS_STORE = "SELECT product_purchase.* , purchase.purchase_date, purchase.total_cost, business_account.b_username \r\n" +
        "FROM product_purchase\r\n" +
        "INNER JOIN purchase ON purchase.purchase_id = product_purchase.purchase_id\r\n" +
        "INNER JOIN business_account ON business_account.b_username = purchase.b_username\r\n" +
        "INNER JOIN product ON product_purchase.product_name = product.product_name\r\n" +
        "WHERE purchase.b_username = ? \r\n" +
        "ORDER BY purchase_id DESC;";

    protected static final String FIND_ALL_STORES_THAT_SELL_A_PRODUCT =
        "SELECT account.*, business_account.store_name, business_account.bank_number, business_account.website, product_store.stock, product_store.price " +
            "FROM product_store, (account INNER JOIN business_account ON account.username = business_account.b_username) " +
            "WHERE product_name = ? AND product_store.b_username = business_account.b_username " +
            "ORDER BY product_store.price ASC;";

    protected final String FIND_PRODUCTS_BY_SUBCATEGORY = "SELECT * FROM product WHERE sub_category = ?;";

    public String getFindProductsBySubcategoryQuery() {
        return FIND_PRODUCTS_BY_SUBCATEGORY;
    }

    protected final String SUBMIT_REVIEW_QUERY = "INSERT INTO product_review(rating,review_body,cust_username,product_name) VALUES (?,?,?,?);";

    public String getSubmitReviewQuery() {
        return SUBMIT_REVIEW_QUERY;
    }

    protected final String FIND_PRODUCT_REVIEWS = "SELECT * FROM product_review WHERE product_name = ? ORDER BY review_date DESC;";

    public String getProductReviewsQuery() {
        return FIND_PRODUCT_REVIEWS;
    }

    protected final String DELETE_REVIEW = "DELETE FROM product_review WHERE cust_username=? AND product_name = ?;";

    public String getDeleteReviewQuery() {
        return DELETE_REVIEW;
    }

    protected final String FIND_PRODUCT_IN_WISHLIST = "SELECT * FROM wishlist WHERE cust_username = ? AND product_name=?;";

    public String getFindProductInWishlistQuery() {
        return FIND_PRODUCT_IN_WISHLIST;
    }


    protected final String ADD_TO_WISHLIST = "INSERT INTO wishlist VALUES(?,?);";
    public String getAddToWishlistQuery() {
        return ADD_TO_WISHLIST;
    }

    protected final String REMOVE_FROM_WISHLIST = "DELETE FROM wishlist WHERE cust_username = ? AND product_name=?;";
    public String getRemoveFromWishlistQuery() {
        return REMOVE_FROM_WISHLIST;
    }

    protected final String FIND_WISHLIST = "SELECT product.* \r\n" +
        "FROM product \r\n" +
        "INNER JOIN wishlist ON wishlist.product_name = product.product_name\r\n" +
        "WHERE wishlist.cust_username = ?;";
    public String getFindWishlistQuery() {
        return FIND_WISHLIST;
    }

    protected final String ADD_PRODUCT_STORE = "insert into  product_store values (?, ?, ?, ?);";
    public String getAddProductStoreQuery() {
        return ADD_PRODUCT_STORE;
    }

    protected final String FIND_STORE_INFO = "SELECT account.*, business_account.* "
        + "FROM account "
        + "INNER JOIN business_account ON account.username = business_account.b_username "
        + "WHERE account.username = ?;";
    public String getFindStoreInfoQuery() {
        return FIND_STORE_INFO;
    }

    protected static String formatDatabaseString(String initialString) {
        String formattedString = initialString.replace("_", " ");
        String printableString = formattedString.substring(0, 1).toUpperCase() + formattedString.substring(1);
        return printableString;
    }


    /*ULTRA DANGER ZONE*/
    protected static final String FIND_ALL_PRODUCTS_THAT_A_STORE_SELLS = "select * from (select product.*, product_store.stock, product_store.price, product_store.b_username  from product_store left join product on  product_store.product_name = product.product_name) as store_products where b_username =?";

    protected static final String UPDATE_PRODUCT_STORE = "update product_store set stock = ?, price = ? where product_name = ? and b_username = ?;";

    protected static final String FIND_PRODUCT_STORE_INFO = "select * from product_store where b_username = ? and product_name = ?";

    protected static final String DELETE_PRODUCT_STORE = "delete from product_store where product_name = ? and b_username=?";

}
