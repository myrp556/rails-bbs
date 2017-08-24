module TextHelper
  def get_pure_text(detail)
    return nil if detail.blank?
    ret = ''
    i = 0
    j = 0
    len = detail.length
    while i < len
      if detail[i] == '&' and detail[i, len].start_with?('&lt;')
        if detail[i,len].start_with?('&lt;br&gt;')
          ret += '&lt;br&gt;';
          i += 10
        else
          j = i+4
          while j < len and !(detail[j]=='&' and detail[j, len].start_with?('&gt;'))
            j += 1
          end
          if j == len
            ret += detail[i, len]
            i = j
          else
            if j < len and detail[j, len].start_with?('&gt;')
              substring = detail[i, j+1]
              ret += "[#{t :image}]" if substring.include?('img') and substring.include?('src')
              ret += "[#{t :link}]" if substring.include?('a') and substring.include?('href')
              ret += '&lt;p&gt;&lt;/p&gt;' if substring.include?('p') and (substring.include?('/'))
              i = j+4
            else
              i += 1
            end
          end
        end
      else
        if detail[i] == '<'
          if detail[i, len].start_with?('<br>')
            ret += '<br>'
            i += 4
          else
            j = i+1
            while j < len and !(detail[j]=='>')
              j += 1
            end
            if j == len
              ret += detail[i, len]
              i = j
            else
              if i < len and detail[j]=='>'
                substring = detail[i, j]
                ret += "[#{t :image}]" if substring.include?('img') and substring.include?('src')
                ret += "[#{t :link}]" if substring.include?('a') and substring.include?('href')
                ret += '<p></p>' if substring.include?('</p>')
                i = j +1
              else
                i += 1
              end
            end
          end
        else
          if detail[i].ord() == 92 or detail[i].ord() == 10
            ret += '<br>'
            i += 1
          else
            ret += detail[i]
            i += 1
          end
        end
      end
    end
    ret
  end
end
