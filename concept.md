Personally I have the same situation in my project with Angular instead of Backbone as a front-end and Rails 4 API with Devise. I will try to sum things up for you in the assumption that I got your question right. 

To work correctly with the sessions in your scenario you need to be sure that:

* Browsers handle communication correctly (i.e. they don't mess with your data because requests do not comply with CORS policies) 
* and, your requests get through Rails CSRF protection

Please, read [this article about CORS](https://developer.mozilla.org/en-US/docs/HTTP/Access_control_CORS). If you are not familiar with CORS the article should provide necessary background for my answer. Some info about CSRF protection is [here](http://guides.rubyonrails.org/security.html#cross-site-request-forgery-csrf)

Here is your scenario step-by-step:

1. Backbone.js sends `GET` request such as 'http://yourserver/signin'
2. Rails Server sends session cookie that will be stored in the browser and CSRF token, which can be stored somewhere within your Backbone application.
3. Backbone.js sends `POST` request with user credentials (name, password) and CSRF token in headers and current unauthorized session in cookies. It is crucial that request contains session information. Otherwise it will be granted different CSRF token on Rails side and you will get `WARNING: Can't verify CSRF token authenticity` message.
4. Backbone.js gets authorized session back if the credentials are correct.

Here is what can be done to get it working:

1. Rails backend should respond correctly to requests from front-end. Which means it should:

* Respond to `OPTIONS` requests (preflight requests)
* Send correct CORS headers
* Able to communicate CSRF token with the front-end

2. Front end should:

* Able to send requests with credentials
* Obtain and use correct CSRF token


The simplest way to teach your Rails back-end to respond to CORS requests is to use
[rack-cors](https://github.com/cyu/rack-cors) gem. This will also provide correct CORS headers.

````ruby
    config.middleware.use Rack::Cors do
      allow do
        origins '*' # it's highly recommended to specify the correct origin
        resource '*', 
            :headers => :any, 
            :methods => [:get, :post, :options], # 'options' is really important 
                                                # for preflight requests
            :expose  => ['X-CSRF-Token']   #allows usage of token on the front-end
      end
    end
```

Last thing on a backend side is to provide CSRF token. Custom Devise controller should handle this task perfectly.

````ruby
    class SessionsController < Devise::SessionsController

        after_action :set_csrf_header, only: [:new, :create, :destroy]
        
        #...

        protected

        def set_csrf_header
          response.headers['X-CSRF-Token'] = form_authenticity_token
        end
    end
```

Note that you need CSRF token when you send first `GET` request (`new`), when you submit credentials through `POST` request (`create`) and when you sign out of your application by sending `DELETE` request (`destroy`). If you don't send CSRF token on sign out you won't be able to sign in without reloading the page.

And somewhere in config/routes.rb don't forget to specify that you are now using custom controller:

    /config/routes.rb
      devise_for :users, :controllers => {:sessions => "sessions"}


Now, to the front-end. Please, have a look at [this script](https://github.com/codebrew/backbone-rails/blob/master/vendor/assets/javascripts/backbone_rails_sync.js) that overrides standard `Backbone.sync` and handles communication with Rails server.
It is almost good with couple of corrections needed:

````javascript


      beforeSend: function( xhr ) {
        if (!options.noCSRF) {
          // we don't have csrf-token in the document anymore  
          //var token = $('meta[name="csrf-token"]').attr('content');
          
          // New Line #1
          // we will get CSRF token from your application.
          // See below for how it gets there.
          var token = YourAppName.csrfToken;
          
          if (token) xhr.setRequestHeader('X-CSRF-Token', token);  

          // New Line #2
          // this will include session information in the requests
          xhr.withCredentials = true;
        }
      
      //..some code omitted
      //................

      // Trigger the sync end event
      var complete = options.complete;
      params.complete = function(jqXHR, textStatus) {
         // New Lines #3,4
         // If response includes CSRF token we need to remember it
         var token = jqXHR.getResponseHeader('X-CSRF-Token') 
         if (token) YourAppName.csrfToken = token;

         model.trigger('sync:end');
         if (complete) complete(jqXHR, textStatus);
      };
     }
```


I'm not sure this qualifies as a complete answer to your question, but at least it is something to start from. Let me know if you have any questions. 