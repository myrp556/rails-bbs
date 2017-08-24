class MailController < ApplicationController
  include PrivilegeHelper
  include PmailHelper
  include TextHelper
  before_action :require_login
  before_action :require_pmail_id, only: [:delete, :get_user_pmail]
  before_action :require_sender_or_receiver, only: [:delete, :get_user_pmail]
  #before_action :require_user_self, only: [:get_user_pmails]

  def main
    @receive_pmails = Pmail.where('receiver_id = ?', @current_user.id).order('updated_at DESC')
    @send_pmails = Pmail.where('sender_id = ?', @current_user.id).order('updated_at DESC')
  end

  def in_box
    @pmails = Pmail.where('receiver_id = ?', @current_user.id).order('updated_at DESC')
    @pmails = @pmails.paginate(page: params[:page], per_page: Settings.pmail_lines_per_page)
  end

  def out_box
    @pmails = Pmail.where('sender_id = ?', @current_user.id).order('updated_at DESC')
    @pmails = @pmails.paginate(page: params[:page], per_page: Settings.pmail_lines_per_page)
  end

  def new
    @pmail = Pmail.new
  end

  def create
    #@pmail = Pmail.new(pmail_params)
    receiver_name = params[:receiver_name]
    if !receiver_name.nil? and receiver_name[0]=='@'
      respond_to do |format|
        found = 0
        if receiver_name == '@all'
          if is_super_user?
            found = 1
            for user in User.all
              make_admin_pmail_to_user user, params[:mail_detail]
            end
            format.json { render json: {'message': t(:send_all_fin)} }
          else
            format.json { render json: {'message': t(:no_privilege)} }
          end
        end
        if found == 0
          format.json { render json: {'message': t(:send_faild)} }
        end
      end
    else
      @pmail = Pmail.new
      @pmail.mail_detail = get_pure_text params[:mail_detail]
      @pmail.sender_name = @current_user.name
      @pmail.sender_id = @current_user.id
      @pmail.receiver_name = params[:receiver_name]
      @receiver = User.find_by(name: params[:receiver_name])

      if @receiver.nil?
        respond_to do |format|
          format.html { (flash[:danger] = t(:user_not_found)) and redirect_to('/') }
          format.json { render(json: {'message': t(:user_not_found)}) }
        end
      end
      @pmail.receiver_id = @receiver.id
      if !@pmail.save()
        respond_to do |format|
          format.html { (flash[:danger] = make_error_message(@pmail)) and redirect_to('/') }
          format.json { render(json: {'message': make_error_message(@pmail)}) }
        end
      else
        #@current_user.pmails << @pmail
        #@receiver.pmails << @pmail
        respond_to do |format|
          format.html { (flash[:success] = t(:send_success)) and redirect_to('/') and return }
          format.json { render(json: {'message': t(:send_success)}) }
        end
      end
    end
  end

  def delete
    if @current_user.pmails.delete(@pmail)
      respond_to do |format|
        format.json { render(json: {'message': t(:delete_success)})}
      end
      if @current_user.id == @pmail.receiver_id
        other = User.find_by(id: @pmail.sender_id)
      else
        other = User.find_by(id: @pmail.receiver_id)
      end
      if other.nil? or other.pmails.find_by(id: @pmail.id).nil?
        @pmail.destroy
      end
    else
      respond_to do |format|
        format.json { render(json: {'message': t(:delete_failed)}) }
      end
    end
  end

  def destroy
    @pmail.destroy
  end

  def get_user_pmails
    sends = []
    for pmail in Pmail.find_by(sender_id: @current_user.id)
      sends.push make_pmail_s(pmail)
    end
    receives = []
    for pmail in Pmail.find_by(receiver_id: @current_user.id)
      receives.push make_pmail_s(pmail)
    end
    respond_to do |format|
      format.json { render(json: {'sends': sends, 'receives': receives} ) }
    end
  end

  def get_user_pmail
    if @current_user.id == @pmail.receiver_id
      @pmail.update(readed: true)
    end
    respond_to do |format|
      format.json { render json: make_pmail_s(@pmail)  }
    end
  end

  private
    def make_pmail_s(pmail)
      {'sender_id': pmail.sender_id, 'sender_name': pmail.sender_name, 'receiver_id': pmail.receiver_id, 'receiver_name': pmail.receiver_name, 'mail_detail': pmail.mail_detail, 'updated_at': pmail.updated_at}
    end
    def pmail_params
      params.require(:pmail).permit(:receiver_id, :mail_detail)
    end

    def require_login
      if !logged_in?
        flash[:info] = t :login_first
        redirect_to '/'
        return
      end
    end

    def require_pmail_id
      @pmail = Pmail.find_by(id: params[:pmail_id])
      if @pmail.nil?
        flash[:info] = t :mail_not_found
        redirect_to '/'
        return
      end
    end

    def require_sender_or_receiver
      if @pmail.sender_id != @current_user.id and @pmail.receiver_id != @current_user.id
        respond_to do |format|
          format.json { render(json: {'message': t(:no_privilege)}) and return}
        end
      end
    end

    def require_user_self
      @user = User.find_by(params[:user_id])
      if @user.nil? or @usr.id != @current_user.id
        respond_to do |format|
          format.json { render(json: {'message': t(:no_privilege)}) and return}
        end
      end
    end
end
