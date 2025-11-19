using AutoMapper;
using OwnerCarService.Models;
using OwnerCarService.Dtos.Car;
using OwnerCarService.Dtos.OwnerCar;

namespace OwnerCarService.Mappers
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
            CreateMap<UpdateOwnerCarDTO, OwnerCar>();
        }
    }
}
