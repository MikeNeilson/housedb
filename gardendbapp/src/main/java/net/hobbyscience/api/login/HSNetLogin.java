package net.hobbyscience.api.login;

import android.util.Log;

import com.example.gardendbapp.data.model.LoggedInUser;
import com.loopj.android.http.AsyncHttpClient;
import com.loopj.android.http.AsyncHttpResponseHandler;
import com.loopj.android.http.RequestParams;
import com.loopj.android.http.TextHttpResponseHandler;

import java.util.concurrent.CountDownLatch;
import java.util.concurrent.TimeUnit;

import cz.msebera.android.httpclient.Header;

public class HSNetLogin {
    private static final String BASE_URL = "https://login.hobbyscience.net/";

    private static AsyncHttpClient client = new AsyncHttpClient();

    public static void get(String url, RequestParams params, AsyncHttpResponseHandler handler){
        client.get(getAbsoluteUrl(url),params,handler);
    }

    public static void post(String url, RequestParams params, AsyncHttpResponseHandler handler){
        client.post(getAbsoluteUrl(url),params,handler);
    }

    public static String getAbsoluteUrl(String relativeUrl){
        return BASE_URL+relativeUrl;
    }

    public static LoggedInUser login(String username, String password, String TOTP){
        final CountDownLatch latch = new CountDownLatch(1);
        client.setBasicAuth(username,password);
        RequestParams params = new RequestParams();
        params.put("totp",TOTP);
        params.setUseJsonStreamer(true);
        final LoggedInUser []user = new LoggedInUser[1];
        user[0] = null;
        post("/token", params, new TextHttpResponseHandler() {
            @Override
            public void onFailure(int statusCode, Header[] headers, String responseString, Throwable throwable) {
                latch.countDown();
                Log.i(HSNetLogin.class.getName(),String.format("Error (%d) %s", statusCode, responseString),throwable);
            }

            @Override
            public void onSuccess(int statusCode, Header[] headers, String responseString) {
                //TODO: parse the JWT and get different info
                user[0] = new LoggedInUser(username,"");
                latch.countDown();
            }
        });
        try {
            latch.await(5, TimeUnit.SECONDS);
            return user[0];
        } catch(InterruptedException err ){
            Log.i("HSNetLogin","Timeout waiting for login response",err);
        }
        return null;
    }

}
