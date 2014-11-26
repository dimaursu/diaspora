class PasswordsController < Devise::PasswordsController
  layout "application", :only => [:new]
end
