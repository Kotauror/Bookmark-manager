feature "update links" do
  scenario "links are updated" do
    visit('/')
    click_button("Update link")
    fill_in("title", with: "Google")
    fill_in("new_title", with: "Cats")
    fill_in("new_url", with: "www.google.com")
    click_button("Update link")
    expect(current_path).to eq '/'
    expect(page).not_to have_content("Google")
  end

  scenario "puts flash message if there is no link" do
    visit("/")
    click_button("Update link")
    fill_in("title", with: "Cats")
    fill_in("new_url", with: "www.cats.com")
    fill_in("new_title", with: "Kitties")
    click_button("Update link")
    expect(page).to have_content("This title cannot be updated as it is not in the database")
  end

  scenario "puts flash message if invalid url" do
    visit("/")
    click_button("Update link")
    fill_in("title", with: "Cats")
    fill_in("new_url", with: "ww.cats.com")
    fill_in("new_title", with: "Kitties")
    click_button("Update link")
    expect(page).to have_content("You have submitted an invalid url")
  end
end
