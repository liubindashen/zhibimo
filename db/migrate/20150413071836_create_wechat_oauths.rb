class CreateWechatOauths < ActiveRecord::Migration
  def change
    create_table :wechat_authentications do |t|
      t.string :access_token
      t.string :refresh_token
      t.string :openid
      t.string :unionid

      t.timestamps null: false
    end
  end
end
