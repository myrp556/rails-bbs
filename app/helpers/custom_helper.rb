module CustomHelper
  include HexHelper

  def make_error_message(model)
    if !model.errors.messages.nil?
      I18n.t(model.errors.messages.keys()[0]) + model.errors.messages[model.errors.messages.keys()[0]][0]
    else
      'rua'
    end
  end

  def get_page(list, object, per_page)
    index = list.index(object) + 1
    num = (index / per_page.to_i).to_i
    num += 1 if index %  per_page.to_i > 0
    return num
  end

  def get_user_name(id)
    user = User.find_by(id: id)
    return nil if user.nil?
    user.name
  end

  def current_user?(user)
    !user.nil? and !@current_user.nil? and user.id == @current_user.id
  end

  def store_location
    session[:forward_url] = request.original_url if request.get?
  end

  # redirect to default location
  # or back to previous page stored in session[:forward_url]
  def redirect_back(default)
    redirect_to(session[:forward_url] || default)
    session.delete(:forward_url)
  end
  # get a file with [ori]'s file format and named with name
  # @ori => 'app.jpg'
  # @nam => 'hex000000000'
  # @ret => 'hex000000000.jpg'
  def rename_with_file_type(ori, nam)
    s = ori.split('.')
    nam + '.' + s[s.length - 1]
  end

  # this method will get first space of @name splited by '.'
  # @name => 'xoxox.http.jpg'
  # @ret => 'xoxox'
  def get_prefix_from_name(nam)
    s = nam.split('.')
    s[0]
  end

  def public_images_dir
    Rails.root.join('public', 'images')
  end

  def public_icon_dir
    public_images_dir().join('icon')
  end

  def update_public_icon(ori_name, file)
    dst = public_icon_dir
    if ori_name.nil?
      return create_file(dst, file)
    else
      return update_file(dst, ori_name, file)
    end
  end

  # delete file in public/iamges/icon, if exist
  def delete_public_icon(name)
    dst = public_icon_dir
    delete_file(dst, name)
  end

  # this method will do new file
  # it will write @file to folder @dst
  # with a new name
  # and name will be return

  def create_file(dst, file)
    hex = create_hex
    file_name = rename_with_file_type(file.original_filename, hex)
    write_to_file(file, dst.join(dst, file_name))
    file_name
  end

  # thie method will do upload file
  # it will delete @ori_name in dir @dst
  # and wirte @file to @dst
  # also check about Hex record
  # finally return a new file name
  def update_file(dst, ori_name, file)
    ori_file = dst.join(ori_name)
    File.delete(ori_file) if File.exist?(ori_file)
    hex = update_hex(get_prefix_from_name(ori_name), new_hex())
    new_name = rename_with_file_type(file.original_filename, hex)
    write_to_file(file, dst.join(new_name))
    new_name
  end

  # this method will do delete fil
  # it will delete file named with @name in folder @dst
  # and also check Hex record
  def delete_file(dst, name)
    ori_file = dst.join(name)
    File.delete(ori_file) if File.exist?(ori_file)
    delete_hex(get_prefix_from_name(name))
    name
  end

  def valid_uploaded_file?(file)
    !file.nil? and !file.equal?('') and file.class.name == "ActionDispatch::Http::UploadedFile"
  end

  def valid_image_file?(file)
    conts = file.original_filename.split('.')
    if conts.length < 2
        return false
    end
    list = ['png', 'icon', 'jpg', 'jpeg', 'bmp', 'ico']
    list.include?(conts[-1])
  end

  def write_to_file(input, dst)
    File.open(dst, 'wb') do |file|
      file.write(input.read)
    end
  end

  def get_time_s(ts)
    if Time.current() - ts < 1.day
      date = t(:today)
    else
      date = ts.strftime('%Y-%m-%d')
    end
    date+' '+ts.strftime('%H:%M')
  end

  def get_time_s_s(ts)
    ts.strftime('%Y-%m-%d %H:%M')
  end
end
