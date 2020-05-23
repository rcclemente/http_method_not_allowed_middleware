Send 405 response for ActionController::UnknownHttpMethod exceptions

Travis CI
=======
[![Build Status](https://travis-ci.org/rcclemente/http_method_not_allowed_middleware.png)](https://travis-ci.org/rcclemente/http_method_not_allowed_middleware)
[![Gem Version](https://badge.fury.io/rb/http_method_not_allowed_middleware.svg)](https://badge.fury.io/rb/http_method_not_allowed_middleware)

Install
=======

```Bash
gem install http_method_not_allowed_middleware
```

Usage
=====

```Ruby
require 'http_method_not_allowed_middleware'
Rails.application.config.middleware.instance_eval do
  insert_before(0, HttpMethodNotAllowedMiddleware)
end
```

Authors
======
[Ryan Clemente](https://github.com/rcclemente)<br/>
kojiee@gmail.com<br/>

[Adrian Bordinc](https://github.com/ellimist)<br/>
adrian.bordinc@gmail.com<br/>
License: MIT<br/>

Gem Template
======
https://github.com/grosser/project_template
