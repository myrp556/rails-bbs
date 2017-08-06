module PageHelper
  def get_in_page(xxoo, page, lines_per_page)
    op = lines_per_page * (page-1)
    all = xxoo.size
    #all = page_all(xxoo, lines_per_page)
    if op>=all
      return nil
    end
    cl = op + lines_per_page
    if cl>=all
      cl = all - 1
    end
    return xxoo.slice(op..cl)
  end
  def page_right(xxoo, page, lines_per_page)
    t = page + 5
    e = page_all(xxoo, lines_per_page)
    if t <= e
      return t
    else
      return e
    end
  end
  def page_left(xxoo, page, lines_per_page)
    t = page - 5
    if t>0
      return t
    else
      return 1
    end
  end
  def page_all(xxoo, lines_per_page)
    t = xxoo.size / lines_per_page
    if xxoo.size % lines_per_page > 0
      t += 1
    end
    t
  end

  def make_up_page(model, lines_per_page)
    all_pages = page_all(model, lines_per_page)
    @page = params[:page]
    if !@page.nil?
      @page = @page.to_i 
      @page = 1 if @page <= 0
      @page = all_pages if @page > all_pages
    else
      @page = 1
    end
    @page_start = 1
    @page_end = all_pages
    @page_left = page_left(model, @page, lines_per_page)
    @page_right = page_right(model, @page, lines_per_page)
    @page_previous = @page - 1 if @page > 1
    @page_next = @page + 1 if @page < all_pages

    get_in_page(model, @page, lines_per_page)
  end
end
