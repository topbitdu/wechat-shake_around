##
# Page Daily Report 是页面每日统计报表的封装类。

class Wechat::ShakeAround::PageDailyReport

  extend Wechat::Core::Common
  extend Wechat::ShakeAround::Common

  ##
  # 以页面为维度的数据统计接口
  # http://mp.weixin.qq.com/wiki/0/8a24bcacad40fe7ee98d1573cb8a6764.html#.E4.BB.A5.E9.A1.B5.E9.9D.A2.E4.B8.BA.E7.BB.B4.E5.BA.A6.E7.9A.84.E6.95.B0.E6.8D.AE.E7.BB.9F.E8.AE.A1.E6.8E.A5.E5.8F.A3
  #
  # Return hash format if success:
  # {
  #   data:
  #   [
  #     {
  #       click_pv: <CLICK_PAGE_VIEW>,
  #       click_uv: <CLICK_USER_VIEW>,
  #       ftime:    <DATE>,            // 当天0点对应的时间戳
  #       shake_pv: <SHAKE_PAGE_VIEW>,
  #       shake_uv: <SHAKE_USER_VIEW>
  #     },
  #     ...
  #   ],
  #   errcode: 0,
  #   errmsg:  'success.'
  # }
  #
  # page_id is an integer 指定页面的ID
  # date_range is a string range like 'yyyy-mm-dd'..'yyyy-mm-dd'.
  def self.index(access_token, page_id, date_range)

    assert_present! :access_token, access_token
    assert_present! :page_id,      page_id
    assert_present! :date_range,   date_range

    message = post_json "https://api.weixin.qq.com/shakearound/statistics/page?access_token=#{access_token}", body:
      {
        page_id:    page_id.to_i,
        begin_date: normalize_date(date_range.min),
        end_date:   normalize_date(date_range.max)
      }
    message.body
  end

end
