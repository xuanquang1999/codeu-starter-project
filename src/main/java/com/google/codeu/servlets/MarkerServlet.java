package com.google.codeu.servlets;

import com.google.appengine.api.datastore.*;
import com.google.codeu.data.Marker;
import com.google.gson.Gson;
import org.jsoup.Jsoup;
import org.jsoup.safety.Whitelist;

import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/markers")
public class MarkerServlet extends HttpServlet {

    // respond with a JSON array containing marker data
    @Override
    public void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException {
        response.setContentType("application/json");

        List<Marker> markers = getMarkers();
        Gson gson = new Gson();
        String json = gson.toJson(markers);

        response.getOutputStream().println(json);
    }

    // fetches markers from Datastore
    private List<Marker> getMarkers() {
        List<Marker> markers = new ArrayList<>();

        DatastoreService datastore = DatastoreServiceFactory.getDatastoreService();
        Query query = new Query("Marker");
        PreparedQuery results = datastore.prepare(query);

        for (Entity entity : results.asIterable()) {
            double lat = (double) entity.getProperty("lat");
            double lng = (double) entity.getProperty("lng");
            String content = (String) entity.getProperty("content");

            Marker marker = new Marker(lat, lng, content);
            markers.add(marker);
        }
        return markers;
    }

    @Override
    public void doPost(HttpServletRequest request, HttpServletResponse response) {
        double lat = Double.parseDouble(request.getParameter("lat"));
        double lng = Double.parseDouble(request.getParameter("lng"));
        String content = Jsoup.clean(request.getParameter("content"), Whitelist.none());

        Marker marker = new Marker(lat, lng, content);
        storeMarker(marker);
    }

    public void storeMarker(Marker marker) {
        Entity markerEntity = new Entity("Marker");
        markerEntity.setProperty("lat", marker.getLat());
        markerEntity.setProperty("lng", marker.getLng());
        markerEntity.setProperty("content", marker.getContent());

        DatastoreService datastore = DatastoreServiceFactory.getDatastoreService();
        datastore.put(markerEntity);
    }
}
