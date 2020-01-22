package group48.enterprice.utilities;

import java.util.ArrayList;
import java.util.List;

import group48.enterprice.model.Filter;

public class Utility {

    public Utility() {

    }

    public <T> ArrayList<T> cloneList(List<T> list) {
        ArrayList<T> clonedList = new ArrayList<T>();
        for(T t : list) {
            clonedList.add(t);
        }
        return clonedList;
    }

    public Filter decodeFilterFromString(String filterString) throws Exception {
        //e.g. filterString = Ram-3GB
        if(filterString.contains("-")) {
            int indexOfDelimeter = filterString.indexOf("-");
            String filterKey = filterString.substring(0, indexOfDelimeter);
            String filterValue = filterString.substring(indexOfDelimeter + 1);
            return new Filter(filterKey, filterValue);
        } else {
            throw new Exception("The filter has not been properly formatted!");
        }
    }
}
