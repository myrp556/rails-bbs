class CkController < ApplicationController
  include CustomHelper
  include UsersHelper
  include PrivilegeHelper

  before_action :require_super_user, except: :index

  private
    def require_super_user
      if !logged_in? or !is_super_user?
        respond_to do |format|
          format.html { render text: 'no privilege' }
        end
        return
      end
    end
end
