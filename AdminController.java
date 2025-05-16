
package com.cooldrinks.controller;

import com.cooldrinks.entity.User;
import com.cooldrinks.repository.UserRepository;
import jakarta.servlet.http.HttpSession;
import org.springframework.context.i18n.LocaleContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

import java.util.Locale;

@Controller
public class AdminController {

    private final UserRepository userRepository;

    public AdminController(UserRepository userRepository) {
        this.userRepository = userRepository;
    }

    @GetMapping("/admin-dashboard")
    public String dashboard(@RequestParam(value = "lang", required = false) String lang, HttpSession session) {
        if (lang != null) {
            session.setAttribute("lang", new Locale(lang));
        }
        return "admin-dashboard"; // maps to admin-dashboard.jsp
    }

    @PostMapping("/admin-login")
    public String login(@RequestParam String email, @RequestParam String password, HttpSession session, Model model) {
        User user = userRepository.findByEmail(email);
        if (user != null && user.getPassword().equals(password)) {
            session.setAttribute("userId", user.getId());
            return "redirect:/admin-dashboard";
        } else {
            model.addAttribute("error", "Invalid credentials");
            return "admin-dashboard";
        }
    }

    @GetMapping("/logout")
    public String logout(HttpSession session) {
        session.invalidate();
        return "redirect:/admin-dashboard";
    }
}
    