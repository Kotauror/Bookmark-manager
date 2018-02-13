feature "add links" do
  scenario "add a new link" do
    visit("/")
    click_button("Add link")
    fill_in("url", with: "http://www.gazeta.pl")
    click_button("Add link")
    expect(page).to have_content("http://www.gazeta.pl")
  end
end
