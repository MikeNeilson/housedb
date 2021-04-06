package com.example.gardendbapp.data;

import com.example.gardendbapp.data.model.LoggedInUser;

import java.io.IOException;
import com.loopj.android.http.*;

import net.hobbyscience.api.login.HSNetLogin;

/**
 * Class that handles authentication w/ login credentials and retrieves user information.
 */
public class LoginDataSource {


    public Result<LoggedInUser> login(String username, String password, String otp) {

        try {
            // TODO: handle loggedInUser authentication
            
            LoggedInUser user = HSNetLogin.login(username,password,otp);
            if( user != null ){
                return new Result.Success<>(user);
            } else {
                return new Result.Error(new Exception("Unable to login"));
            }

        } catch (Exception e) {
            return new Result.Error(new IOException("Error logging in", e));
        }
    }

    public void logout() {
        // TODO: revoke authentication
    }
}