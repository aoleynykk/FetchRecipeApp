//
//  FetchRecipeAppTests.swift
//  FetchRecipeAppTests
//
//  Created by Alex Oliynyk on 13.03.2025.
//

import XCTest
@testable import FetchRecipeApp

class RecipeViewModelTests: XCTestCase {

    var viewModel: RecipeViewModel!
    var mockService: MockRecipeService!

    override func setUp() {
        super.setUp()
        mockService = MockRecipeService(httpClient: HTTPClientDecorator(client: URLSession.shared))
        viewModel = RecipeViewModel(service: mockService)
    }

    override func tearDown() {
        viewModel = nil
        mockService = nil
        super.tearDown()
    }

    func testFetchRecipesSuccess() async {
        mockService.fetchSuccess = true

        await viewModel.fetchRecipes()

        XCTAssertEqual(viewModel.recipes.count, 3)
        XCTAssertNil(viewModel.errorMessage)
    }

    func testFetchRecipesFailure() async {
        mockService.fetchSuccess = false

        await viewModel.fetchRecipes()

        XCTAssertEqual(viewModel.recipes.count, 0)
        XCTAssertEqual(viewModel.errorMessage, "Error Message\nError")
    }

    func testFetchEmptyRecipes() async {
        mockService.fetchSuccess = true
        mockService.returnEmptyRecipes = true

        await viewModel.fetchRecipes()

        XCTAssertTrue(viewModel.recipes.isEmpty)
        XCTAssertNil(viewModel.errorMessage)
    }
}

class RecipeCellTests: XCTestCase {

    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        super.tearDown()
    }

    func testImageCache() async {
        let cachedImage = UIImage(systemName: "star")
        ImageCache.shared.saveImage(cachedImage!, for: "test_url")

        let cached = ImageCache.shared.getImage(for: "test_url")

        XCTAssertEqual(cached, cachedImage)
    }
}
