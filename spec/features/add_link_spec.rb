feature "add links" do
  scenario "add a valid new link" do
    visit("/")
    click_button("Add link")
    fill_in("url", with: "http://www.gazeta.pl")
    fill_in("title", with: "Gazeta")
    click_button("Add link")
    expect(page).to have_content("Gazeta")
  end
  scenario "add a invalid link" do
    visit("/")
    click_button("Add link")
    fill_in("url", with: "jydshkuwf")
    click_button("Add link")
    expect(page).to have_content("You have submitted an invalid url")
  end
end
