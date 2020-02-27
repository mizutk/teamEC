package com.internousdev.bianco.action;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import org.apache.struts2.interceptor.SessionAware;

import com.internousdev.bianco.dao.CartInfoDAO;
import com.internousdev.bianco.dao.UserInfoDAO;
import com.internousdev.bianco.dto.CartInfoDTO;
import com.internousdev.bianco.util.InputChecker;
import com.opensymphony.xwork2.ActionSupport;

public class LoginAction extends ActionSupport implements SessionAware {
	private String userId;
	private String password;
	private boolean savedUserIdFlg;
	private List<String> userIdErrorMessageList;
	private List<String> passwordErrorMessageList;
	private String isNotUserInfoMessage;
	private List<CartInfoDTO> cartInfoDTOList;
	private int totalPrice;
	private Map<String, Object> session;

	public String execute() throws SQLException {
		String result = ERROR;
		UserInfoDAO userInfoDAO = new UserInfoDAO();
		session.remove("savedUserIdFlg");

		if (session.containsKey("createUserFlg")
				&& Integer.parseInt(session.get("createUserFlg").toString()) == 1) {
			userId = session.get("userIdForCreateUser").toString();

			session.remove("userIdForCreateUser");
			session.remove("createUserFlg");

		} else {
			InputChecker inputChecker = new InputChecker();
			userIdErrorMessageList = inputChecker.doCheck("ユーザーID", userId, 1, 8, true, false, false, true, false,
					false);
			passwordErrorMessageList = inputChecker.doCheck("パスワード", password, 1, 16, true, false, false, true, false,
					false);

			if (userIdErrorMessageList.size() > 0
					|| passwordErrorMessageList.size() > 0) {
				session.put("logined", 0);
				return result;
			}

			if (!userInfoDAO.isExistsUserInfo(userId, password)) {
				isNotUserInfoMessage = "ユーザーIDまたはパスワードが異なります。";
				return result;
			}
		}

		if (!session.containsKey("tmpUserId")) {
			return "sessionTimeout";
		}
		CartInfoDAO cartInfoDAO = new CartInfoDAO();
		String tmpUserId = session.get("tmpUserId").toString();
		List<CartInfoDTO> cartInfoForTmpUser = cartInfoDAO.getCartInfo(tmpUserId);
		if (cartInfoForTmpUser != null && cartInfoForTmpUser.size() > 0) {
			boolean cartResult = changeCartInfo(cartInfoForTmpUser, tmpUserId);
			if (!cartResult) {
				return "DBError";
			}
		}

		session.put("userId", userId);
		session.put("logined", 1);
		if (savedUserIdFlg) {
			session.put("savedUserIdFlg", true);
		}
		session.remove("tmpUserId");

		if (session.containsKey("cartFlg")
				&& Integer.parseInt(session.get("cartFlg").toString()) == 1) {
			session.remove("cartFlg");
			cartInfoDTOList = cartInfoDAO.getCartInfo(userId);
			totalPrice = cartInfoDAO.getTotalPrice(userId);
			result = "cart";
		} else {
			result = SUCCESS;
		}
		return result;
	}

	private boolean changeCartInfo(List<CartInfoDTO> cartInfoForTmpUser, String tmpUserId) throws SQLException {
		int count = 0;
		CartInfoDAO cartInfoDAO = new CartInfoDAO();
		boolean result = false;

		for (CartInfoDTO cartInfoDTO : cartInfoForTmpUser) {
			if (CartInfoDAO.isExistCart(userId, cartInfoDTO.getProductId())) {
				count += cartInfoDAO.productUpDate(userId, cartInfoDTO.getProductId(), cartInfoDTO.getProductCount());
				cartInfoDAO.tmpDelete(tmpUserId, cartInfoDTO.getProductId());
			} else {
				count += cartInfoDAO.linkToUserId(userId, tmpUserId, cartInfoDTO.getProductId());
			}
		}
		if (count == cartInfoForTmpUser.size()) {
			result = true;
		}
		return result;
	}

	public Map<String, Object> getSession() {
		return session;
	}

	@Override
	public void setSession(Map<String, Object> session) {
		this.session = session;
	}

	public String getUserId() {
		return userId;
	}

	public void setUserId(String userId) {
		this.userId = userId;
	}

	public String getPassword() {
		return password;
	}

	public void setPassword(String password) {
		this.password = password;
	}

	public String getIsNotUserInfoMessage() {
		return isNotUserInfoMessage;
	}

	public void setIsNotUserInfoMessage(String isNotUserInfoMessage) {
		this.isNotUserInfoMessage = isNotUserInfoMessage;
	}

	public boolean getSavedUserIdFlg() {
		return savedUserIdFlg;
	}

	public void setSavedUserIdFlg(boolean savedUserIdFlg) {
		this.savedUserIdFlg = savedUserIdFlg;
	}

	public List<CartInfoDTO> getCartInfoDTOList() {
		return cartInfoDTOList;
	}

	public void setCartInfoDTOList(List<CartInfoDTO> cartInfoDTOList) {
		this.cartInfoDTOList = cartInfoDTOList;
	}

	public List<String> getUserIdErrorMessageList() {
		return userIdErrorMessageList;
	}

	public void setUserIdErrorMessageList(List<String> userIdErrorMessageList) {
		this.userIdErrorMessageList = userIdErrorMessageList;
	}

	public List<String> getPasswordErrorMessageList() {
		return passwordErrorMessageList;
	}

	public void setPasswordErrorMessageList(List<String> passwordErrorMessageList) {
		this.passwordErrorMessageList = passwordErrorMessageList;
	}

	public int getTotalPrice() {
		return totalPrice;
	}

	public void setTotalPrice(int totalPrice) {
		this.totalPrice = totalPrice;
	}
}
