require 'rails_helper'

RSpec.describe 'User sign in' do
  scenario 'Invalid user cannot sign in', js: true do
    visit unauthenticated_root_path

    expect(page).to have_content 'Log in'

    fill_in :user_email, with: FFaker::Internet.email
    fill_in :user_password, with: FFaker::Lorem.word
    click_button 'Log in'

    expect(page).to have_content 'Invalid Email or password.'
  end

  scenario 'Valid user can sign in successfully' do
    user = create(:user, password: '123456', password_confirmation: '123456')

    visit unauthenticated_root_path

    expect(page).to have_content 'Log in'

    fill_in :user_email, with: user.email
    fill_in :user_password, with: user.password
    click_button 'Log in'

    expect(page).to have_content 'Signed in successfully.'
  end
end