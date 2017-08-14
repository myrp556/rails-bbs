module HexHelper
   # get a random hex code in unique!
  # all hex record used stored in Model.Hex
  # hex.url is the code of it!
  def new_hex
    url = SecureRandom.hex(16)
    while Hex.find_by(url: url)
      url = SecureRandom.hex(16)
    end
    url
  end

  def create_hex
    url = new_hex
    Hex.create(url: url)
    url
  end

  # delete a hex record with url of it, if exist!
  def delete_hex(url)
    hex = Hex.find_by(url: url)
    hex.destroy() if !hex.nil?
  end

  # update a hex record with url, if it exist!
  def update_hex(url1, url2)
    hex = Hex.find_by(url: url1)
    if hex.nil?
      r = Hex.create(url: url2)
      puts r
    else
      hex.update(url: url2)
    end
    url2
  end


end
