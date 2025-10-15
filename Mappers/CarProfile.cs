using AutoMapper;
using SDCRMS.Models;
using SDCRMS.Dtos.Car;

namespace SDCRMS.Mappers
{
    public class CarProfile : Profile
    {
        public CarProfile()
        {
            CreateMap<Car, CarDTO>().ReverseMap();
            CreateMap<CreateCarDTO, Car>();
            CreateMap<UpdateCarDTO, Car>();
            CreateMap<OwnerCar, OwnerCarDTO>().ReverseMap();
            CreateMap<CreateOwnerCarDTO, OwnerCar>();
            CreateMap<Maintenance, MaintenanceDTO>().ReverseMap();
            CreateMap<CreateMaintenanceDTO, Maintenance>();
            CreateMap<UpdateMaintenanceDTO, Maintenance>();
        }
    }
}
