
import axiosClient from "./axiosClient";

const API_BASE = "/OwnerCar";

  const res = await axiosClient.get(API_BASE);
  return res.data;
};

  const res = await axiosClient.post(API_BASE, data);
  return res.data;
};

  const res = await axiosClient.put(`${API_BASE}/${id}`, data);
  return res.data;
};

  const res = await axiosClient.delete(`${API_BASE}/${id}`);
  return res.data;
};
