package com.soe.product.entity;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import lombok.Data;

import javax.persistence.*;
import java.util.List;

@Entity
@Data
@Table(name="product")
public class Product {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name="id")
    private Long id;

    @Column(name="name")
    private String name;

    @Column(name="description")
    private String description;

    @Column(name="price")
    private Integer price;

    @Column(name="stock")
    private Integer  stock;


    @Column(name="image_url")
    private String  image_url;

    @ManyToOne
    @JoinColumn(name="category_id", nullable=true)
    @JsonIgnoreProperties({"products"})
    private Category category;


    public String getCategoryName() {
        return (this.category != null) ? this.category.getCategoryName() : "No Category";
    }
}
