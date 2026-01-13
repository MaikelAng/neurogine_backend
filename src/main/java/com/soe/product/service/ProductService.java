package com.soe.product.service;

import com.soe.product.entity.Product;
import com.soe.product.repository.ProductRepository;
import com.soe.product.entity.Category;
import com.soe.product.repository.CategoryRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;
import java.nio.file.*;
import java.io.IOException;
import java.util.UUID;

import java.util.List;
import java.util.Optional;


@Service
public class ProductService {
    @Autowired
    private ProductRepository productRepository;

    @Autowired
    private CategoryRepository categoryRepository;

    public List<Product> findAll() {
        return productRepository.findAll();
    }

    public Optional<Product> findById(Long id) {
        return productRepository.findById(id);
    }

    public Product save(Product product) {
        System.out.println("=== DEBUG: Saving new product ===");
        System.out.println("Product name: " + product.getName());
        System.out.println("Category in request: " +


        (product.getCategory() != null ? product.getCategory().getId() : "null"));

        if (product.getCategory() != null && product.getCategory().getId() != null) {
            Long categoryId = product.getCategory().getId();
            System.out.println("Looking for category ID: " + categoryId);

            Optional<Category> categoryOpt = categoryRepository.findById(categoryId);
            if (categoryOpt.isPresent()) {
                Category managedCategory = categoryOpt.get();
                System.out.println("Found category: " + managedCategory.getCategoryName());


                Category newCategory = createCategoryCopy(managedCategory);
                product.setCategory(newCategory);
            } else {
                System.out.println("Category not found! Setting to null.");
                product.setCategory(null);
            }
        } else {
            System.out.println("No category ID provided.");
        }

        Product saved = productRepository.save(product);
        System.out.println("Saved product ID: " + saved.getId());
        System.out.println("Image URL: " + product.getImage_url());
        System.out.println("Saved product category: " +
                (saved.getCategory() != null ? saved.getCategory().getId() : "null"));
        System.out.println("=== END DEBUG ===\n");

        return saved;
    }

    public Optional<Product> updateProduct(Long id, Product productDetails) {
        System.out.println("=== DEBUG: Updating product ===");
        System.out.println("Product ID to update: " + id);
        System.out.println("New product name: " + productDetails.getName());

        if (productDetails.getCategory() != null) {
            System.out.println("Category in request - ID: " + productDetails.getCategory().getId());
            System.out.println("Category in request - Name: " + productDetails.getCategory().getCategoryName());
        } else {
            System.out.println("NO CATEGORY in request body!");
        }

        Optional<Product> optionalProduct = productRepository.findById(id);

        if (optionalProduct.isPresent()) {
            Product product = optionalProduct.get();
            System.out.println("Found existing product:");
            System.out.println("Current category: " +
                    (product.getCategory() != null ?
                            product.getCategory().getId() + " - " + product.getCategory().getCategoryName() :
                            "null"));

            product.setName(productDetails.getName());
            product.setDescription(productDetails.getDescription());
            product.setPrice(productDetails.getPrice());
            product.setStock(productDetails.getStock());
            product.setImage_url(productDetails.getImage_url());

            if (productDetails.getCategory() != null && productDetails.getCategory().getId() != null) {
                Long categoryId = productDetails.getCategory().getId();
                System.out.println("Processing category ID: " + categoryId);

                Optional<Category> categoryOpt = categoryRepository.findById(categoryId);

                if (categoryOpt.isPresent()) {
                    Category managedCategory = categoryOpt.get();
                    System.out.println("Found category in DB: " + managedCategory.getCategoryName());

                    Category newCategory = createCategoryCopy(managedCategory);
                    product.setCategory(newCategory);

                } else {
                    System.out.println("WARNING: Category ID " + categoryId + " not found in database!");
                    product.setCategory(null);
                }
            } else {
                System.out.println("No category to update");
                product.setCategory(null);
            }

            System.out.println("Before save - Product category ID: " +
                    (product.getCategory() != null ? product.getCategory().getId() : "null"));

            Product savedProduct = productRepository.save(product);

            System.out.println("After save - Product category ID: " +
                    (savedProduct.getCategory() != null ? savedProduct.getCategory().getId() : "null"));
            System.out.println("=== UPDATE COMPLETE ===\n");

            return Optional.of(savedProduct);
        }

        System.out.println("Product not found with ID: " + id);
        System.out.println("=== UPDATE FAILED ===\n");
        return Optional.empty();
    }

    private Category createCategoryCopy(Category original) {
        if (original == null) return null;

        Category copy = new Category();
        copy.setId(original.getId());
        copy.setCategoryName(original.getCategoryName());
        copy.setDescription(original.getDescription());
        return copy;
    }

    public boolean deleteById(Long id) {
        if (productRepository.existsById(id)) {
            productRepository.deleteById(id);
            return true;
        }
        return false;
    }

    public String saveImage(MultipartFile file) throws IOException {

        if (file.isEmpty()) {
            throw new RuntimeException("File is empty");
        }

        String uploadDir = "uploads";
        Files.createDirectories(Paths.get(uploadDir));

        String filename = UUID.randomUUID() + "_" + file.getOriginalFilename();
        Path filePath = Paths.get(uploadDir, filename);

        Files.copy(file.getInputStream(), filePath, StandardCopyOption.REPLACE_EXISTING);

        return "http://localhost:8090/uploads/" + filename;
    }
}