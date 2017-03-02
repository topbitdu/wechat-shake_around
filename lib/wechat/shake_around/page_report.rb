##
# Page Report 是页面统计报表的封装类。

class Wechat::ShakeAround::PageReport

  extend Wechat::Core::Common
  extend Wechat::ShakeAround::Common

  ##
  # 批量查询页面统计数据接口
  # http://mp.weixin.qq.com/wiki/0/8a24bcacad40fe7ee98d1573cb8a6764.html#.E6.89.B9.E9.87.8F.E6.9F.A5.E8.AF.A2.E9.A1.B5.E9.9D.A2.E7.BB.9F.E8.AE.A1.E6.95.B0.E6.8D.AE.E6.8E.A5.E5.8F.A3
  #
  # Return hash format if success:
  # {
  #   data:
  #   {
  #     pages:
  #     [
  #       {
  #         page_id:  <PAGE_ID>,
  #         shake_pv: <SHAKE_PAGE_VIEW>,
  #         shake_uv: <SHAKE_USER_VIEW>,
  #         click_pv: <CLICK_PAGE_VIEW>,
  #         click_uv: <CLICK_USER_VIEW>
  #       },
  #       ...
  #     ]
  #   },
  #   date:        <DATE>,        // 所查询的日期时间戳
  #   total_count: <TOTAL_COUNT>, // 页面总数
  #   page_index:  <PAGE_INDEX>,  // 所查询的结果页序号；返回结果按摇周边人数降序排序，每50条记录为一页
  #   errcode:     0,
  #   errmsg:      'success.'
  # }
  #
  # date:       指定查询日期时间戳，单位为秒。
  # page_index: 指定查询的结果页序号；返回结果按摇周边人数降序排序，每50条记录为一页 ，从1开始。
  def self.index(access_token, date, page_index: 1)

    assert_present! :access_token, access_token
    assert_present! :date,         date
    assert_present! :page_index,   page_index

    message = post_json "https://api.weixin.qq.com/shakearound/statistics/pagelist?access_token=#{access_token}", body:
      {
        date:       normalize_date(date),
        page_index: page_index.to_i
      }
    message.body
  end

end
