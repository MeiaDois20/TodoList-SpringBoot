package br.com.thalysravel.TodoList.user;

import java.time.LocalDateTime;
import java.util.UUID;

import org.hibernate.annotations.CreationTimestamp;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.Id;
import lombok.Data;

@Data //Coloca os Getters(@Getter) e Setter(@Setter) automaticamente

@Entity(name = "tb_users")
public class UserModel {

    //@Getter e @Setter podem ser colocados em cima dos atributos tbm
    @Id
    @GeneratedValue(generator = "UUID")
    private UUID id;

    @Column(nullable = false, unique = true)
    private String username;
    private String name;
    private String password;

    @CreationTimestamp
    private LocalDateTime createdAt;
}
