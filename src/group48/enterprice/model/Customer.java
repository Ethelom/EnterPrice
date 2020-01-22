package group48.enterprice.model;

import java.util.ArrayList;

import group48.enterprice.database.CustomerDAO;
import group48.enterprice.database.UserDAO;
import group48.enterprice.database.WishlistDAO;
import group48.enterprice.exceptions.IntruderException;

public class Customer extends User {

    private Cart cart;
    private ArrayList<Product> wishlist;

    public Customer(String username, String fullname, String email, String password, AddressInfo adInfo, String image) {
        super(username, fullname, email, password, adInfo, image);
        this.wishlist = new ArrayList<Product>();
        this.cart = new Cart();
    }

    @Override
    public UserDAO getDAO() {
        return new CustomerDAO(this);
    }

    @Override
    public String getNavbarSrc() {
        return "navbarCustomer.jsp";
    }

    @Override
    public String getHomePageSrc() {
        return "homePage.jsp";
    }

    @Override
    public String getSearchBarForwardSrc() {
        // TODO Auto-generated method stub
        return "searchSubcategories.jsp";
    }

    @Override
    public void preloadData() throws Exception {
        //CustomerDAO cdao = new CustomerDAO(this);
        WishlistDAO wishlistDAO = new WishlistDAO();
        this.wishlist = wishlistDAO.loadWishlist(this);
    }

    public void updateWishlist(Product targetedProduct) {
        int productCounter = 0, positionIndex = -1;
        for(Product product : this.wishlist) {
            if(product.equals(targetedProduct)) {
                positionIndex = productCounter;
            }
            productCounter++;
        }
        if(positionIndex != -1) {
            wishlist.remove(positionIndex);
        } else {
            wishlist.add(targetedProduct);
        }
    }

    public boolean hasInWishlist(Product productToCheck) {
        for(Product product : this.wishlist) {
            if (product.equals(productToCheck)) {
                return true;
            }
        }
        return false;
    }

    public ArrayList<Product> getWishlist() {
        return wishlist;
    }

    public void setWishlist(ArrayList<Product> wishlist) {
        this.wishlist = wishlist;
    }

    public Cart getCart() {
        return cart;
    }

    public void setCart(Cart cart) {
        this.cart = cart;
    }

    @Override
    public String getTypeOfUser() {
        return "customer";
    }

    @Override
    public Customer castToSelf(Object x) throws IntruderException {
        try {
            return (Customer) x;
        } catch(ClassCastException e) {
            throw new IntruderException();
        }
    }

}
