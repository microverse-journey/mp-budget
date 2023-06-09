require 'rails_helper'

describe 'Group show page', type: :feature do
  before(:each) do
    @user = User.create(
      name: 'name',
      email: 'user@test1.com',
      password: 'password',
      confirmed_at: Time.now
    )

    # add groups
    @groups = []
    2.times do |x|
      groups = Group.create(name: "Test Group #{x}", user: @user)
      groups.icon.attach(
        io: File.open(Rails.root.join('spec', 'fixtures', 'files', 'dominos.png')),
        filename: 'dominos.png',
        content_type: 'image/png'
      )
      groups.save
      Purchase.create(name: "test purchase #{x}", amount: 100, author: @user, group: groups)
      Purchase.create(name: "test purchase #{x}", amount: 50, author: @user, group: groups)
      @groups << groups
    end

    visit user_session_path

    fill_in 'Email', with: 'user@test1.com'
    fill_in 'Password', with: 'password'
    click_button 'Log in'

    visit group_path(@groups[0])
  end

  it 'Should display the Add purchase link' do
    expect(page).to have_link('Add new purchase')
  end

  it 'Should display the total amount of the group' do
    expect(page).to have_content('150.00')
  end

  it 'When user click on Add new purchase link, they are taken to the new purchase page' do
    click_link('Add new purchase')

    expect(page).to have_current_path(new_group_purchase_path(@groups[0]))
  end
end
