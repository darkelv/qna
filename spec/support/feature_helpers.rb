module FeatureHelpers
  def sign_in user
    visit new_user_session_path
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    click_on 'Log in'
  end

  def search_in(keywords, resource = "all")
    fill_in "Search", with: keywords
    select(resource, from: 'search_resource')
    click_on "Search"
  end
end
