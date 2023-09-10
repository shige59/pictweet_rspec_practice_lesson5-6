require 'rails_helper'

RSpec.describe 'ユーザー新規登録', type: :system do
  before do
    @user = FactoryBot.build(:user)
  end
  context 'ユーザー新規登録ができるとき' do 
    it '正しい情報を入力すればユーザー新規登録ができてトップページに移動する' do
      visit root_path
      # トップページに移動する
      expect(page).to have_content('新規登録')
      # トップページにサインアップページへ遷移するボタンがあることを確認する
      visit new_user_registration_path
      # 新規登録ページへ移動する
      fill_in 'Nickname', with: @user.nickname
      fill_in 'Email', with: @user.email
      fill_in 'Password', with: @user.password
      fill_in 'Password confirmation', with: @user.password_confirmation
      # ユーザー情報を入力する
      expect{
        find('input[name="commit"]').click
        sleep 1
      }.to change{ User.count }.by(1)
      # サインアップボタンを押すとユーザーモデルのカウントが1上がることを確認する
      expect(page).to have_current_path(root_path)

      # トップページへ遷移することを確認する
      expect(
        find('.user_nav').find('span').hover
      ).to have_content('ログアウト')
      # カーソルを合わせるとログアウトボタンが表示されることを確認する
      expect(page).to have_no_content('新規登録')
      expect(page).to have_no_content('ログイン')
      # サインアップページへ遷移するボタンやログインページへ遷移するボタンが表示されていないことを確認する
    end
  end
  context 'ユーザー新規登録ができないとき' do
    it '誤った情報ではユーザー新規登録ができずに新規登録ページへ戻ってくる' do
      # トップページに移動する
      visit root_path
      # トップページにサインアップページへ遷移するボタンがあることを確認する
      expect(page).to have_content('新規登録')
      # 新規登録ページへ移動する
      visit new_user_registration_path
      # ユーザー情報を入力する
      fill_in 'Nickname', with: ''
      fill_in 'Email', with: ''
      fill_in 'Password', with: ''
      fill_in 'Password confirmation', with: ''
      # サインアップボタンを押してもユーザーモデルのカウントは上がらないことを確認する
      expect{
        find('input[name="commit"]').click
        sleep 1
      }.to change{ User.count }.by(0)
      # 新規登録ページへ戻されることを確認する
      expect(current_path).to eq(new_user_registration_path)
    end
  end
end
