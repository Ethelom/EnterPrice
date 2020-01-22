package group48.enterprice.model;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

public class Filter {

    private String key, value;

    public Filter(String key, String value) {
        super();
        this.key = key;
        this.value = value;
    }

    public List<Product> applyFilter(List<Product> list) {
        List<Product> subList = new ArrayList<Product>();
        for(Product product : list) {
            for (Map.Entry<String, String> spec : product.getSpecs().entrySet()) {
                String key = spec.getKey();
                String value = spec.getValue();

                if(this.key.equals(key) && this.value.equals(value)) {
                    subList.add(product);
                }

            }
        }

        return subList;
    }

    public String getKey() {
        return key;
    }

    public void setKey(String key) {
        this.key = key;
    }

    public String getValue() {
        return value;
    }

    public void setValue(String value) {
        this.value = value;
    }


    @Override
    public String toString() {
        return this.key;
    }

}
