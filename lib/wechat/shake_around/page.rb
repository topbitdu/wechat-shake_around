require 'jsonclient'

class Wechat::ShakeAround::Page

  extend Wechat::Core::Common
  extend ::Wechat::ShakeAround::Common

  # 查询页面列表
  # http://mp.weixin.qq.com/wiki/5/6626199ea8757c752046d8e46cf13251.html#.E6.9F.A5.E8.AF.A2.E9.A1.B5.E9.9D.A2.E5.88.97.E8.A1.A8
  #
  # Return hash format if success:
  # {
  #   data:
  #   {
  #     pages:
  #     [
  #       {
  #         comment:     <COMMENT>,     // 页面的备注信息
  #         description: <DESCRIPTION>, // 在摇一摇页面展示的副标题
  #         icon_url:    <ICON_LINK>,   // 在摇一摇页面展示的图片
  #         page_id:     <PAGE_ID>,     // 摇周边页面唯一ID 
  #         page_url:    <PAGE_LINK>,   // 跳转链接
  #         title:       <TITLE>        // 在摇一摇页面展示的主标题
  #       },
  #       ...
  #     ],
  #     total_count: <TOTAL_COUNT>      // 商户名下的页面总数
  #   },
  #   errcode:     0,
  #   errmsg:      'success.'
  # }
  def self.index(access_token, offset, limit)

    assert_present! :access_token, access_token
    assert_present! :offset, offset
    assert_present! :limit, limit

    message = ::JSONClient.new.post "https://api.weixin.qq.com/shakearound/page/search?access_token=#{access_token}",
      {
        type:  2, 
        begin: offset.to_i,
        count: limit.to_i
      }
    message.body
  end

  # 查询页面列表
  # http://mp.weixin.qq.com/wiki/5/6626199ea8757c752046d8e46cf13251.html#.E6.9F.A5.E8.AF.A2.E9.A1.B5.E9.9D.A2.E5.88.97.E8.A1.A8
  #
  # Return hash format if success:
  # {
  #   data:
  #   {
  #     pages:
  #     [
  #       {
  #         comment:     <COMMENT>,     // 页面的备注信息
  #         description: <DESCRIPTION>, // 在摇一摇页面展示的副标题
  #         icon_url:    <ICON_LINK>,   // 在摇一摇页面展示的图片
  #         page_id:     <PAGE_ID>,     // 摇周边页面唯一ID 
  #         page_url:    <PAGE_LINK>,   // 跳转链接
  #         title:       <TITLE>        // 在摇一摇页面展示的主标题
  #       },
  #       ...
  #     ],
  #     total_count: <TOTAL_COUNT>      // 商户名下的页面总数
  #   },
  #   errcode:     0,
  #   errmsg:      'success.'
  # }
  #
  # page_id 可以是数字、整数或者它们的数组。
  def self.load(access_token, page_id)

    assert_present! :access_token, access_token
    assert_present! :page_id, page_id
    #raise ArgumentError.new('The access_token argument is required.') if access_token.blank?

    message = ::JSONClient.new.post "https://api.weixin.qq.com/shakearound/page/search?access_token=#{access_token}",
      {
        type:     1,
        page_ids: normalize_page_ids(page_id)
      }
    message.body
  end

  # 删除页面
  # http://mp.weixin.qq.com/wiki/5/6626199ea8757c752046d8e46cf13251.html#.E5.88.A0.E9.99.A4.E9.A1.B5.E9.9D.A2
  #
  # Return hash format if success:
  # {
  #   data:    {},
  #   errcode: 0,
  #   errmsg:  'success.'
  # }
  def self.destroy(access_token, page_id)

    assert_present! :access_token, access_token
    assert_present! :page_id, page_id
    #raise ArgumentError.new('The access_token argument is required.') if access_token.blank?

    message = ::JSONClient.new.post "https://api.weixin.qq.com/shakearound/page/delete?access_token=#{access_token}", { page_id: page_id.to_i }
    message.body
  end

  # 编辑页面信息
  # http://mp.weixin.qq.com/wiki/5/6626199ea8757c752046d8e46cf13251.html#.E7.BC.96.E8.BE.91.E9.A1.B5.E9.9D.A2.E4.BF.A1.E6.81.AF
  #
  # Return hash format if success:
  # {
  #   data:    {},
  #   errcode: 0,
  #   errmsg:  'success.'
  # }
  #
  # title       在摇一摇页面展示的主标题，不超过6个汉字或12个英文字母。
  # description 在摇一摇页面展示的副标题，不超过7个汉字或14个英文字母。
  # comment     页面的备注信息，不超过15个汉字或30个英文字母。
  # icon_link   在摇一摇页面展示的图片。图片需先上传至微信侧服务器，用“素材管理-上传图片素材”接口上传图片，返回的图片URL再配置在此处。 
  def self.update(access_token, page_id, title, description, comment, page_link, icon_link)

    assert_present! :access_token, access_token
    assert_present! :page_id, page_id
    assert_present! :title, title
    assert_present! :description, description
    assert_present! :comment, comment
    assert_present! :page_link, page_link
    assert_present! :icon_link, icon_link
    #raise ArgumentError.new('The access_token argument is required.') if access_token.blank?

    message = ::JSONClient.new.post "https://api.weixin.qq.com/shakearound/page/update?access_token=#{access_token}",
      {
        page_id:     page_id.to_i,
        title:       title,
        description: description,
        page_url:    page_link,
        comment:     comment,
        icon_url:    icon_link
      }
    message.body
  end

  # 新增页面
  # http://mp.weixin.qq.com/wiki/5/6626199ea8757c752046d8e46cf13251.html#.E6.96.B0.E5.A2.9E.E9.A1.B5.E9.9D.A2
  #
  # Return hash format if success:
  # {
  #   data:    { page_id: <PAGE_ID> },
  #   errcode: 0,
  #   errmsg:  'success.'
  # }
  #
  # title       在摇一摇页面展示的主标题，不超过6个汉字或12个英文字母。
  # description 在摇一摇页面展示的副标题，不超过7个汉字或14个英文字母。
  # comment     页面的备注信息，不超过15个汉字或30个英文字母。
  # icon_link   在摇一摇页面展示的图片。图片需先上传至微信侧服务器，用“素材管理-上传图片素材”接口上传图片，返回的图片URL再配置在此处。 
  def self.create(access_token, title, description, comment, page_link, icon_link)

    assert_present! :access_token, access_token
    assert_present! :title, title
    #raise ArgumentError.new('The access_token argument is required.') if access_token.blank?

    message = ::JSONClient.new.post "https://api.weixin.qq.com/shakearound/page/add?access_token=#{access_token}",
      {
        title:       title,
        description: description,
        page_url:    page_link,
        comment:     comment,
        icon_url:    icon_link
      }
    message.body
  end

end
