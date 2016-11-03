require 'jsonclient'

class Wechat::ShakeAround::DeviceDailyReport

  extend Wechat::Core::Common
  extend Wechat::ShakeAround::Common

  # 以设备为维度的数据统计接口
  # http://mp.weixin.qq.com/wiki/0/8a24bcacad40fe7ee98d1573cb8a6764.html#.E4.BB.A5.E8.AE.BE.E5.A4.87.E4.B8.BA.E7.BB.B4.E5.BA.A6.E7.9A.84.E6.95.B0.E6.8D.AE.E7.BB.9F.E8.AE.A1.E6.8E.A5.E5.8F.A3
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
  # device_id is an integer or a hash like { uuid: <UUID>, major: <MAJOR>, minor: <MINOR> }.
  # date_range is a string range like 'yyyy-mm-dd'..'yyyy-mm-dd'.
  def self.index(access_token, device_id, date_range)

    assert_present! :access_token, access_token
    assert_present! :device_id, device_id
    assert_present! :date_range, date_range

    device_identifier = normalize_device_id device_id

    message = ::JSONClient.new.post "https://api.weixin.qq.com/shakearound/statistics/device?access_token=#{access_token}",
      {
        device_identifier: device_identifier,
        begin_date:        normalize_date(date_range.min), 
        end_date:          normalize_date(date_range.max)
      }
    message.body

  end

end
