require 'jsonclient'

class Wechat::ShakeAround::Group

  extend Wechat::Core::Common
  extend Wechat::ShakeAround::Common

  # 查询分组列表
  # http://mp.weixin.qq.com/wiki/10/9f6b498b6aa0eb5ef6b9ab5a70cc8fba.html#.E6.9F.A5.E8.AF.A2.E5.88.86.E7.BB.84.E5.88.97.E8.A1.A8
  #
  # Return hash format if success:
  # {
  #   data:
  #   {
  #     groups:
  #     [
  #       {
  #         group_id:   <GROUP_ID>,
  #         group_name: <GROUP_NAME>
  #       },
  #       ...
  #     ],
  #     total_count: <TOTAL_COUNT> // 此账号下现有的总分组数
  #   },
  #   errcode: 0,
  #   errmsg:  "success."
  # }
  #
  # offset: 分组列表的起始索引值
  # limit: 待查询的分组数量，不能超过1000个
  def self.index(access_token, offset: 0, limit: 1000)

    assert_present! :access_token, access_token

    message = ::JSONClient.new.post "https://api.weixin.qq.com/shakearound/device/group/getlist?access_token=#{access_token}",
      {
        begin: offset.to_i,
        count: limit.to_i
      }
    message.body
  end

  # 查询分组详情
  # http://mp.weixin.qq.com/wiki/10/9f6b498b6aa0eb5ef6b9ab5a70cc8fba.html#.E6.9F.A5.E8.AF.A2.E5.88.86.E7.BB.84.E8.AF.A6.E6.83.85
  #
  # Return hash format if success:
  # {
  #   data:
  #   {
  #     group_id:    <GROUP_ID>,
  #     group_name:  <GROUP_NAME>,
  #     total_count: <TOTAL_COUNT>, // 此分组现有的总设备数
  #     devices:
  #     [
  #       {
  #         device_id: <DEIVCE_ID>,
  #         uuid:      <UUID>,
  #         major:     <MAJOR>,
  #         minor:     <MINOR>,
  #         comment:   <COMMENT>,
  #         poi_id:    <POI_ID>
  #       },
  #       ...
  #     ]
  #   },
  #   errcode: 0,
  #   errmsg:  "success."
  # }
  #
  # group_id: 分组唯一标识，全局唯一
  # offset: 分组里设备的起始索引值
  # limit: 待查询的分组里设备的数量，不能超过1000个
  def self.load(access_token, group_id, offset: 0, limit: 1000)

    assert_present! :access_token, access_token
    assert_present! :group_id,     group_id

    message = ::JSONClient.new.post "https://api.weixin.qq.com/shakearound/device/group/getdetail?access_token=#{access_token}",
      {
        group_id: group_id.to_i,
        begin:    offset.to_i,
        count:    limit.to_i
      }
    message.body
  end

  # 删除分组
  # http://mp.weixin.qq.com/wiki/10/9f6b498b6aa0eb5ef6b9ab5a70cc8fba.html#.E5.88.A0.E9.99.A4.E5.88.86.E7.BB.84
  #
  # Return hash format if success:
  # {
  #   data:    {},
  #   errcode: 0,
  #   errmsg:  "success."
  # }
  #
  # group_id: 分组唯一标识，全局唯一
  def self.destroy(access_token, group_id)

    assert_present! :access_token, access_token
    assert_present! :group_id,     group_id
    #raise ArgumentError.new('The access_token argument is required.') if access_token.blank?

    message = ::JSONClient.new.post "https://api.weixin.qq.com/shakearound/device/group/delete?access_token=#{access_token}", { group_id: group_id.to_i }
    message.body
  end

  # 编辑分组信息
  # http://mp.weixin.qq.com/wiki/10/9f6b498b6aa0eb5ef6b9ab5a70cc8fba.html#.E7.BC.96.E8.BE.91.E5.88.86.E7.BB.84.E4.BF.A1.E6.81.AF
  #
  # Return hash format if success:
  # {
  #   data:    {},
  #   errcode: 0,
  #   errmsg:  "success."
  # }
  #
  # group_id: 分组唯一标识，全局唯一
  # name: 分组名称，不超过100汉字或200个英文字母
  def self.update(access_token, group_id, name)

    assert_present! :access_token, access_token
    assert_present! :group_id,     group_id
    assert_present! :name,         name
    #raise ArgumentError.new('The access_token argument is required.') if access_token.blank?

    message = ::JSONClient.new.post "https://api.weixin.qq.com/shakearound/device/group/update?access_token=#{access_token}",
      {
        group_id:   group_id.to_i,
        group_name: name
      }
    message.body
  end

  # 新增分组
  # http://mp.weixin.qq.com/wiki/10/9f6b498b6aa0eb5ef6b9ab5a70cc8fba.html#.E6.96.B0.E5.A2.9E.E5.88.86.E7.BB.84
  #
  # Return hash format if success:
  # {
  #   data:
  #   {
  #     group_id:   <GROUP_ID>,
  #     group_name: <GROUP_NAME>
  #   },
  #   errcode: 0,
  #   errmsg:  "success."
  # }
  #
  # name: 分组名称，不超过100汉字或200个英文字母
  def self.create(access_token, name)

    assert_present! :access_token, access_token
    assert_present! :name,         name
    #raise ArgumentError.new('The access_token argument is required.') if access_token.blank?

    message = ::JSONClient.new.post "https://api.weixin.qq.com/shakearound/device/group/add?access_token=#{access_token}", { group_name: name }
    message.body
  end

end
