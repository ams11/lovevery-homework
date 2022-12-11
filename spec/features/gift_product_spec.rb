require 'rails_helper'

RSpec.feature "Gift Product", type: :feature do
  scenario "Creates a gift and redirects correctly" do
    product = Product.create!(
      name: "product1",
      description: "description2",
      price_cents: 1000,
      age_low_weeks: 0,
      age_high_weeks: 12,
      )
    child_name = "Kim Jones"
    parent_name = "Pat Jones"
    birthdate = "2019-03-03"
    child = Child.create!(
      full_name: child_name,
      birthdate: birthdate,
      parent_name: parent_name,
    )
    address = Address.create!(
      shipping_name: parent_name,
      address: "1234 Broad St",
      zipcode: "12345",
    )
    order = Order.create!(
      product_id: product.id,
      child_id: child.id,
      address_id: address.id,
      paid: true,
    )

    visit "/"

    within ".products-list .product" do
      click_on "More Details…"
    end

    click_on "Gift"

    gift_message = "Happy Birthday!!!"
    fill_in "gift[credit_card_number]", with: "4111111111111111"
    fill_in "gift[expiration_month]", with: 12
    fill_in "gift[expiration_year]", with: 25
    fill_in "gift[shipping_name]", with: parent_name
    fill_in "gift[child_full_name]", with: child_name
    fill_in "gift[child_birthdate]", with: birthdate
    fill_in "gift[gift_comment]", with: gift_message

    click_on "Purchase"

    expect(page).to have_content("Thanks for Your Gift")
    expect(page).to have_content(Gift.last.user_facing_id)
    expect(page).to have_content("(Gift)")
    expect(page).to have_content(gift_message)
    expect(page).to have_content(child_name)
  end

  scenario "Reports an error if the child could not be found in the database" do
    product = Product.create!(
      name: "product1",
      description: "description2",
      price_cents: 1000,
      age_low_weeks: 0,
      age_high_weeks: 12,
      )

    visit "/"

    within ".products-list .product" do
      click_on "More Details…"
    end

    click_on "Gift"

    gift_message = "Happy Birthday!!!"
    fill_in "gift[credit_card_number]", with: "4111111111111111"
    fill_in "gift[expiration_month]", with: 12
    fill_in "gift[expiration_year]", with: 25
    fill_in "gift[shipping_name]", with: "The Mandalorian"
    fill_in "gift[child_full_name]", with: "Baby Yoda"
    fill_in "gift[child_birthdate]", with: "2022-05-04"
    fill_in "gift[gift_comment]", with: gift_message

    click_on "Purchase"

    expect(page).to have_content("Check Out")
    expect(page).to have_content(product.name)
    expect(page).to have_content("Child must exist,Shipping address must exist,Shipping address can't be blank,Child can't be blank")
  end

  scenario "Can match the child's address from another Gift for a different product" do
    product1 = Product.create!(
      name: "product1",
      description: "description2",
      price_cents: 1000,
      age_low_weeks: 0,
      age_high_weeks: 12,
      )
    product2 = Product.create!(
      name: "product1",
      description: "description2",
      price_cents: 1000,
      age_low_weeks: 0,
      age_high_weeks: 12,
      )
    child_name = "Kim Jones"
    parent_name = "Pat Jones"
    birthdate = "2019-03-03"
    child = Child.create!(
      full_name: child_name,
      birthdate: birthdate,
      parent_name: parent_name,
      )
    address = Address.create!(
      shipping_name: parent_name,
      address: "1234 Broad St",
      zipcode: "12345",
      )
    gift = Gift.create!(
      product_id: product2.id,
      child_id: child.id,
      address_id: address.id,
      paid: true,
      )

    visit "/products/#{product1.id}"

    click_on "Gift"

    fill_in "gift[credit_card_number]", with: "4111111111111111"
    fill_in "gift[expiration_month]", with: 12
    fill_in "gift[expiration_year]", with: 25
    fill_in "gift[shipping_name]", with: parent_name
    fill_in "gift[child_full_name]", with: child_name
    fill_in "gift[child_birthdate]", with: birthdate

    click_on "Purchase"

    expect(page).to have_content("Thanks for Your Gift")
    last_gift = Gift.find_by(product_id: product1.id, child_id: child.id)
    expect(page).to have_content(last_gift.user_facing_id)
    expect(page).to have_content("(Gift)")
    expect(page).to have_content(child_name)
  end

  scenario "Tells us when there was a problem charging our card" do
    product = Product.create!(
      name: "product1",
      description: "description2",
      price_cents: 1000,
      age_low_weeks: 0,
      age_high_weeks: 12,
      )
    child_name = "Kim Jones"
    parent_name = "Pat Jones"
    birthdate = "2019-03-03"
    child = Child.create!(
      full_name: child_name,
      birthdate: birthdate,
      parent_name: parent_name,
      )
    address = Address.create!(
      shipping_name: parent_name,
      address: "1234 Broad St",
      zipcode: "12345",
      )
    order = Order.create!(
      product_id: product.id,
      child_id: child.id,
      address_id: address.id,
      paid: true,
      )

    visit "/"

    within ".products-list .product" do
      click_on "More Details…"
    end

    click_on "Gift"

    fill_in "gift[credit_card_number]", with: "4242424242424242"
    fill_in "gift[expiration_month]", with: 12
    fill_in "gift[expiration_year]", with: 25
    fill_in "gift[shipping_name]", with: parent_name
    fill_in "gift[child_full_name]", with: child_name
    fill_in "gift[child_birthdate]", with: birthdate

    click_on "Purchase"

    expect(page).not_to have_content("Thanks for Your Gift")
    expect(page).to have_content("Problem with your gift")
    expect(page).to have_content(Gift.last.user_facing_id)
    expect(page).to have_content(child_name)
  end

  scenario "returns an error if the gift message is too long" do
    product = Product.create!(
      name: "product1",
      description: "description2",
      price_cents: 1000,
      age_low_weeks: 0,
      age_high_weeks: 12,
      )
    child_name = "Kim Jones"
    parent_name = "Pat Jones"
    birthdate = "2019-03-03"
    child = Child.create!(
      full_name: child_name,
      birthdate: birthdate,
      parent_name: parent_name,
      )
    address = Address.create!(
      shipping_name: parent_name,
      address: "1234 Broad St",
      zipcode: "12345",
      )
    order = Order.create!(
      product_id: product.id,
      child_id: child.id,
      address_id: address.id,
      paid: true,
      )

    visit "/"

    within ".products-list .product" do
      click_on "More Details…"
    end

    click_on "Gift"

    gift_message = "foo" * 101
    fill_in "gift[credit_card_number]", with: "4111111111111111"
    fill_in "gift[expiration_month]", with: 12
    fill_in "gift[expiration_year]", with: 25
    fill_in "gift[shipping_name]", with: parent_name
    fill_in "gift[child_full_name]", with: child_name
    fill_in "gift[child_birthdate]", with: birthdate
    fill_in "gift[gift_comment]", with: gift_message

    click_on "Purchase"

    expect(page).to have_content("Check Out")
    expect(page).to have_content(product.name)
    expect(page).to have_content("Gift comment cannot exceed 300 characters.")
  end

  scenario "Redirects to home page and shows an error if product doesn't exist on new gift page" do
    Product.create!(
      name: "product1",
      description: "description2",
      price_cents: 1000,
      age_low_weeks: 0,
      age_high_weeks: 12,
      )
    visit "/gifts/new?product_id=#{Product.maximum(:id).next}"

    expect(page).to have_content("Products")
    expect(page).to have_content("Product not found")
  end
end
